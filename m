From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH nfsim] backquote bugfixes, extension_path changes,
	command "echo"
Date: Wed, 12 Oct 2005 20:09:19 +1000
Message-ID: <1129111759.8218.75.camel@localhost.localdomain>
References: <20051010221049.GA32155@roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Max Kellermann <max@duempel.org>
In-Reply-To: <20051010221049.GA32155@roonstrasse.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 2005-10-11 at 00:10 +0200, Max Kellermann wrote:
> Hi Rusty,
> 
> I have found three bugs in your changes to my backquote patches, the
> following patches fix them.

Thanks Max!

	Since it looks like we're going to work together more and more in the
future, I'll comment on these patches in detail.  They're not wrong, but
my projects have a preferred style (which, unfortunately for you, you
can only figure out by mails like this).

I've applied the first fix (line[i]), no changes.  I changed your
out-by-one fix because it makes as much sense for backquote() to only
process up to the trailing quote (it adds one, then we subtract one).  I
think this makes it slightly more readable, but needs a comment still:
        --- core/tui.c	(revision 4344)
        +++ core/tui.c	(working copy)
        @@ -274,7 +274,7 @@
         	return dest;
         }
         
        -/* Process `command`. */
        +/* Process `command`: update off to point to tail backquote */
         static char *backquote(char *line, unsigned int *off)
         {
         	char *end, *cmdstr, *str;
        @@ -296,8 +296,8 @@
         		script_fail("failed to popen '%s': %s\n",
         			    cmdstr, strerror(errno));
         
        -	/* Jump over tail backquote. */
        -	*off += len + 1;
        +	/* Jump to backquote. */
        +	*off += len;
         
         	/* Read command output. */
         	used = 0;

The echo patch was great, logical, exactly how I would have done it.
Except that the recent change to ensure argv[] is a talloc pointer means
we can hang the buffer off this, and it will be freed for us after the
command is run.  I also fixed the synopsis XML, and removed a trailing
line.  So here are the changes:

        --- tools/echo.c	2005-10-11 21:09:10.000000000 +1000
        +++ tools/echo-new.c	2005-10-11 21:05:11.000000000 +1000
        @@ -34,9 +34,6 @@
              <title><command>echo</command></title>
              <para>Print a message</para>
              <cmdsynopsis>
        -      <arg choice="req"><replaceable>text...</replaceable></arg>
        -     </cmdsynopsis>
        -     <cmdsynopsis>
               <command>echo</command>
               <arg choice="req"><replaceable>text...</replaceable></arg>
              </cmdsynopsis>
        @@ -47,26 +44,13 @@
         
         static bool echo(int argc, char **argv)
         {
        -	char buffer[8192];
        -	size_t length = 0, next_length;
        +	char *buffer;
         	int i;
         
        -	for (i = 1; i < argc; i++) {
        -		next_length = strlen(argv[i]);
        -		if (length + next_length + 1 >= sizeof(buffer)) {
        -			nfsim_log(LOG_ALWAYS, "Argument list too long");
        -			return false;
        -		}
        -
        -		if (length > 0)
        -			buffer[length++] = ' ';
        -
        -		memcpy(buffer + length, argv[i], next_length);
        -		length += next_length;
        -	}
        -
        -	buffer[length] = 0;
        -
        +	buffer = talloc_strdup(argv, "");
        +	for (i = 1; i < argc; i++)
        +		buffer = talloc_asprintf_append(buffer, "%s%s",
        +						i == 1 ? "" : " ", argv[i]);
         	nfsim_log(LOG_ALWAYS, "%s", buffer);
         
         	return true;
        @@ -78,4 +62,3 @@
         }
         
         init_call(init);
        -
        
Finally, you no doubt realize that the code to allow backquote within an
argument was ugly.  I thought about this, and decided to use this
solution:

        Index: core/tui.c
        ===================================================================
        --- core/tui.c	(revision 4344)
        +++ core/tui.c	(working copy)
        @@ -321,36 +321,50 @@
         	return escape(str, used);
         }
         
        +static char *append_char(char **argv, unsigned int argc, char c)
        +{
        +	if (!argv[argc])
        +		return talloc_asprintf(argv, "%c", c);
        +	return talloc_asprintf_append(argv[argc], "%c", c);
        +}
        +
        +static char *append_string(char **argv, unsigned int argc, const char *str)
        +{
        +	if (!argv[argc])
        +		return talloc_asprintf(argv, "%s", str);
        +	return talloc_asprintf_append(argv[argc], "%s", str);
        +}
        +
         static void process_line(char *line, unsigned int off)
         {
         	unsigned int argc, i;
        -	bool prevspace = true;
         	char **argv;
         
         	if (tui_echo_commands)
         		printf("%u:%s\n", tui_linenum, line + off);
         
         	/* Talloc argv off line so commands can use it for auto-cleanup. */
        -	argv = talloc_array(line, char *, TUI_MAX_ARGS+1);
        +	argv = talloc_zero_array(line, char *, TUI_MAX_ARGS+1);
         	argc = 0;
         	for (i = off; line[i]; i++) {
         		if (isspace(line[i])) {
        -			line[i] = '\0';
        -			prevspace = true;
        +			/* If anything in this arg, move to next. */
        +			if (argv[argc])
        +				argc++;
         		} else if (line[i] == '`') {
        -			/* FIXME: Assumes ` forms arg by itself. */
        -			argv[argc++] = backquote(line, &i);
        -		} else if (prevspace) {
        +			char *inside = backquote(line, &i);
        +			argv[argc] = append_string(argv, argc, inside);
        +		} else {
         			/* If it is a comment, stop before we process `` */
        -			if (argc == 0 && line[i] == '#')
        +			if (!argv[0] && line[i] == '#')
         				goto out;
        -			argv[argc++] = line+i;
        -			prevspace = false;
        +
        +			argv[argc] = append_char(argv, argc, line[i]);
         		}
         	}
         
        -	if (argc > 0) {
        -		argv[argc] = NULL;
        +	if (argv[0]) {
        +		argv[++argc] = NULL;
         		tui_do_command(argc, argv, tui_abort_on_fail);
         	}
         
        
-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
