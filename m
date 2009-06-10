From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] Add support unified match/target files to iptables
Date: Wed, 10 Jun 2009 14:05:39 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0906101402100.30984@fbirervta.pbzchgretzou.qr>
References: <alpine.DEB.2.00.0906091505160.23699@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34700 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662AbZFJMFi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jun 2009 08:05:38 -0400
In-Reply-To: <alpine.DEB.2.00.0906091505160.23699@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2009-06-09 15:12, Jozsef Kadlecsik wrote:
>
>The patch below adds supporting unified match/target files - and the 
>possibility to lowercase all target files - to iptables. There are a 
>couple of match/target pairs (say mark/MARK), which could be covered in a 
>single file, but the current search logic prevents it. The patch modifies 
>the searching with adding an extra check with lowercased filename for 
>targets. Comments are welcomed!

I like it.

> static void *load_extension(const char *search_path, const char *prefix,
>     const char *name, bool is_target)
> {
> 	const char *dir = search_path, *next;
> 	void *ptr = NULL;
>-	struct stat sb;
>-	char path[256];
>+	char lcname[XT_FUNCTION_MAXNAMELEN-1];
>+	unsigned int fmtlen;
>+	int i;
>+
>+	if (is_target)
>+		for (i = 0; name[i] && i < XT_FUNCTION_MAXNAMELEN - 1; i++)
>+			lcname[i] = tolower(name[i]);

This needs to check for name[i] == '\0'.

> 	do {
> 		next = strchr(dir, ':');
> 		if (next == NULL)
> 			next = dir + strlen(dir);
> 
>+		fmtlen = (unsigned int)(next - dir);

Cast is not needed. It only was previously in place, because fmtlen was
calculated directly during the call to sprintf and would not always have
type unsigned int; by storing it to a variable, you explicitly make it
unsigned int.
