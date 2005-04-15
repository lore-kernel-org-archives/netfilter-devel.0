From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: [patch] fix ACCOUNT locking
Date: Fri, 15 Apr 2005 18:08:37 +0200
Message-ID: <200504151808.37519.thomas.jarosch@intra2net.com>
References: <200504151024.28858.thomas.jarosch@intra2net.com>
	<20050415155430.GG25433@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
In-Reply-To: <20050415155430.GG25433@sunbeam.de.gnumonks.org>
Content-Disposition: inline
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

Hello Harald,

> > attached is a patch to fix ipt_ACCOUNT locking. ipt_ACCOUNT now works
> > finally for large networks without trouble.
>
> somehow I was neither able to apply this patch to what we had in
> patch-o-matic-ng, nor incremental to your last email from April 05.
>
> > The full version can be found here:
> > http://www.intra2net.com/opensource/ipt_account/
>
> I've downloaded the latest version from there and merged it into
> patch-o-matic.

Thanks, looks good. Though I'm not sure about the change
in the "info" file, is the "Recompile: " line still ok?

Old: "Recompile: kernel, iptables"
New: "Recompile: netfilter"

Also the title line is gone now...

Thomas
