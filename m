From: Lucas Brasilino <brasilino@prrr.mpf.gov.br>
Subject: Is 'iptables-restore' not caching EOF ??
Date: Tue, 25 Jul 2006 09:51:11 -0400
Message-ID: <44C621CF.6050700@prrr.mpf.gov.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi All:

Hope this issue isn't off-topic.
I'm developing a daemon which authenticates a user and creates
netfilter rules based on user profile.
Following Harald's advise, during FISL 7.0 here in Brazil, he said
to open a pipe to 'iptables-restore --noflush' rather than
fork()ing/exec()ing lots of 'iptables' binary. And I'm doing that.
My problem is that I fork(), dup2() and execv()
'iptables-restore' and then I write() from parent end of the pipe
and close() it, the 'iptables-restore' forked child seems not
receiving EOF because it isn't exiting. And I need the
exit status to verify if rules was created.

I've tried two way of writing to the pipe and closing it:

First try:

ret = write(CommIptablesRestore[COMM_WRITE], buffer, strlen (buffer));
close(CommIptablesRestore[COMM_WRITE]);

Second try (as of 'iptables-restore' reading code):

FILE *fp = NULL;
fp = fdopen(CommIptablesRestore[COMM_WRITE], "w");
fputs(buffer, fp);
fflush(fp);
fclose(fp);

Where 'CommIptablesRestore[COMM_WRITE]' is the parent end of pipe
filedescriptor and 'buffer' stores rules until 'COMMIT\n'.

So after closing my daemon exits and 'iptables-restore' does
not exits and stills on sleep status. Using 'strace' I can see
that 'iptables-restore' stills read()ing STDIN. So seems
it is not caching 'EOF' to exit.

Is that a feature, bug or I'm messing something up?

I didn´t post where a full code snippet to avoid mailing list
pollution... but I can send directly.

Thanks a lot in advance.

-- 
[]'s

Lucas Brasilino
brasilino@prrr.mpf.gov.br
Procuradoria da República no Estado de Roraima
+55-95-36239642
