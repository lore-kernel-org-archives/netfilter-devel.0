From: Brad Fisher <brad@info-link.net>
Subject: Re: [PATCH] Minor fix for patchlets which modify multiple projects
Date: Thu, 13 May 2004 11:09:42 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40A39DC6.C3F78CA3@info-link.net>
References: <40A2754C.F4AA6CEF@info-link.net> <40A2E52C.3010103@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy wrote:

> Thanks Brad, I've applied a small variation of this, because I don't know if
> perl will complain about two equally named variables (@projects and %projects)
> with warnings turned on.

I don't think your patch is quite right.  You can end up having the same project listed multiple
times with your patch, which is why I used the separate hash - key collisions are reduced to single
entries.  I guess as long as it is no problem for a project to be processed multiple times, then
your patch will be OK, but if that isn't the case, you may want to look into it again.

As far as variables with the same name and different types, I don't believe Perl complains.  I
typically program with 'use strict', which I believe enables all warnings, and have used naming
like this before.  Of course it does add quite a bit of ambiguity, so renaming the %projects hash
would probably be a good idea if you choose to use a variation of my patch.

> Regards
> Patrick

-Brad
