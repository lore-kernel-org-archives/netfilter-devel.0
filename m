From: Harald Welte <laforge@gnumonks.org>
Subject: Re: iptables questions
Date: Tue, 2 Jul 2002 23:05:00 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020702210500.GF19439@naboo.rchrd.phub.net.cable.rogers.com>
References: <023d01c1ae2b$f0f417c0$9d264484@cs.technion.ac.il> <20020219212055.M22074@sunbeam.de.gnumonks.org> <03ce01c1eae8$d580e0f0$9d264484@cmp41> <20020423190905.X27024@sunbeam.de.gnumonks.org> <011001c221c1$32508e20$9b264484@cmp41>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Vladimir Getselevich <vladg@techunix.technion.ac.il>
Content-Disposition: inline
In-Reply-To: <011001c221c1$32508e20$9b264484@cmp41>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jul 02, 2002 at 03:08:37PM +0300, Vladimir Getselevich wrote:
> Hi, Harald.
> 
> I asked you this question, but you didn't answered me.
> Could you please tell me how can I cause that there will not be a delay of 1
> packet in ULOG.
> It is very important for my master research.

Well, you have the sourcecode so it should be pretty easy to find out.

I'd try to set flushtimeout=0 at the modprobe commandline.

> You say that this is an option of  ipt_ULOG module. How can I configure it
> to deliver packets immediately without a delay.

just read the ipt_ULOG.c

> Best regards,
>   Vladimir

-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
