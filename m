From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] build: allow disabling libreadline-support
Date: Thu, 9 Oct 2014 18:33:10 +0200
Message-ID: <20141009163310.GA10706@salvia>
References: <1412200742-5898-1-git-send-email-cyrus@openwrt.org>
 <20141009122648.GA17919@salvia>
 <1412866961.4287.1.camel@openwrt.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="cWoXeonUoKmBZSoM"
Cc: netfilter-devel@vger.kernel.org
To: Steven Barth <cyrus@openwrt.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41049 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbaJIQbt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Oct 2014 12:31:49 -0400
Content-Disposition: inline
In-Reply-To: <1412866961.4287.1.camel@openwrt.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 09, 2014 at 05:02:41PM +0200, Steven Barth wrote:
> > Please, add the:
> > 
> > #ifdef HAVE_LIBREADLINE
> > 
> > in cli_init() and cli_exit() in cli.c. It would be good if the cli_init()
> > returns a negative value, so you spot the error message below.
> 
> The problem I see here that this would basically mean enclosing most of
> cli.c in #ifdef HAVE_LIBREADLINE to avoid depending on readline-headers
> and having a rather awkward stub of cli_init in the no-readline case.
> 
> My main point of excluding cli.c in the Makefile from the start is to
> avoid this madness.

I see, then I'd suggest something like the change (applies on top of
your patch).

Would you merge this to your patch, including the --without-cli option
and resend? Thanks.


--cWoXeonUoKmBZSoM
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/include/nftables.h b/include/nftables.h
index 3394e32..c3d3dbf 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -31,7 +31,14 @@ extern unsigned int debug_level;
 extern const char *include_paths[INCLUDE_PATHS_MAX];
 
 struct parser_state;
+#ifdef HAVE_LIBREADLINE
 extern int cli_init(struct parser_state *state);
+#else
+static inline int cli_init(struct parser_state *state)
+{
+	return -1;
+}
+#endif
 extern void cli_exit(void);
 extern void cli_display(const char *fmt, va_list ap) __fmtstring(1, 0);
 
diff --git a/src/main.c b/src/main.c
index de2efe6..8dc0768 100644
--- a/src/main.c
+++ b/src/main.c
@@ -335,14 +335,12 @@ int main(int argc, char * const *argv)
 		if (scanner_read_file(scanner, filename, &internal_location) < 0)
 			goto out;
 	} else if (interactive) {
-#ifdef HAVE_LIBREADLINE
-		cli_init(&state);
+		if (cli_init(&state) < 0) {
+			fprintf(stderr, "%s: CLI not supported in this build\n",
+				argv[0]);
+			exit(NFT_EXIT_FAILURE);
+		}
 		return 0;
-#else
-		fprintf(stderr, "%s: interactive CLI not supported in this build\n",
-			argv[0]);
-		exit(NFT_EXIT_FAILURE);
-#endif
 	} else {
 		fprintf(stderr, "%s: no command specified\n", argv[0]);
 		exit(NFT_EXIT_FAILURE);

--cWoXeonUoKmBZSoM--
