Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8401345732
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Dec 2025 13:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766066004; cv=none; b=fIK439vLTylC+z7+2n42mfdfb2mZCKjNtIfsvinMb3tIi0VAXfDbkUpKpOZBudY1FFR1roSMUJAJoN4PItWZApEoBLw3bafAjyAQItqQozZb0zjHuQLZ2z15ES6uFH3f0gr1ExcVbLe6sfLwkJukhGuTGBgZdisENeCC0BJeAps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766066004; c=relaxed/simple;
	bh=3jo35742t6aV7esD0eI/03aftGF5v47QVe1rKzbSV7s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sv479N3mmFhGtxNQiVcL2PMgcwzcCAlpVgUiz0vzcL/QaonP1LLll+vjRPqBe5fqntiKGBE01iZldVLXYTvthCtH6j58YLJqyAZAfUPRE2wW1JUx1F4XtHlbKkpqoJCxEIk8SsE+qw30UoHuH/VbVoshcvHIlPNc+3FFyCZg+YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=RVJRkFQB; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="RVJRkFQB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=0+3g7XvOukYqefMzvUNYolKZt7/IlE59f70EjUTphf0=; b=RVJRkFQBLKlTN1lSStgnOHUg0B
	q8V4bbL2RpPG4B7J8tR8saS6KrSO8Bwk4NgrSc5aCiQsdPaYKOCWBWlENhiLpNK1k1Td7VJXHwgYH
	XWZ2JDVtrevAzpdtzmJ7eiOzOCYS2mMx4vQOWubgF8Tm+YPmdHXiw8qxT1NZz4A4+sk34jCSV/O55
	b9R/dADoVpSeX+eIx4bRahJ81mPCrL+3/irB7C02LFsPJR8jjm+ErZgvdePlSkp13NRfX31kPuTLA
	jBTxS6PnLzGHgDOKck/Hd0sikqV00aqRYrGxK08z9MoEv4IjN3291sZq106k+E7jcmzmch9MOYYI7
	6brhRMRg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vWERL-000000007qZ-1x9J;
	Thu, 18 Dec 2025 14:53:11 +0100
Date: Thu, 18 Dec 2025 14:53:11 +0100
From: Phil Sutter <phil@nwl.cc>
To: Ilia Kashintsev <ilia.kashintsev@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: Null dereference in ebtables-restore.c
Message-ID: <aUQHRzlp0dg5KZ_x@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Ilia Kashintsev <ilia.kashintsev@gmail.com>,
	netfilter-devel@vger.kernel.org
References: <CAF6ebR7PoBEpheSSjsSZqxUJh3yPeh1KjGTuGWsG0KwbuhJKMQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF6ebR7PoBEpheSSjsSZqxUJh3yPeh1KjGTuGWsG0KwbuhJKMQ@mail.gmail.com>

Hi,

On Thu, Dec 18, 2025 at 04:17:39PM +0300, Ilia Kashintsev wrote:
> Hello maintainers! I have found a SEGV in ebtables-restore.c
> 
> It occurs on the following line:
> *strchr(cmdline, '\n') = '\0';
> 
> If '\n' is not present in cmdline, then the result of strchr() is NULL
> with a dereference attempt afterwards.

Thanks for the detailed report!

[...]
> Suggested fix:
> 
> Check strchr() result before trying to dereference it.
> 
> diff --git a/ebtables-restore.c b/ebtables-restore.c
> index bb4d0cf..c97364b 100644
> --- a/ebtables-restore.c
> +++ b/ebtables-restore.c
> @@ -76,7 +76,9 @@ int main(int argc_, char *argv_[])
>                 line++;
>                 if (*cmdline == '#' || *cmdline == '\n')
>                         continue;
> -               *strchr(cmdline, '\n') = '\0';
> +               char *new_line = strchr(cmdline, '\n');
> +               if (new_line)
> +                       *new_line = '\0';
>                 if (*cmdline == '*') {
>                         if (table_nr != -1) {
>                                 ebt_deliver_table(&replace[table_nr]);

How about simply using strchrnul():

--- a/ebtables-restore.c
+++ b/ebtables-restore.c
@@ -17,6 +17,7 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
+#define _GNU_SOURCE
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -76,7 +77,7 @@ int main(int argc_, char *argv_[])
                line++;
                if (*cmdline == '#' || *cmdline == '\n')
                        continue;
-               *strchr(cmdline, '\n') = '\0';
+               *strchrnul(cmdline, '\n') = '\0';
                if (*cmdline == '*') {
                        if (table_nr != -1) {
                                ebt_deliver_table(&replace[table_nr]);

Cheers, Phil
