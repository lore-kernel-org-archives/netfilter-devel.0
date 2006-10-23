From: Patrick McHardy <kaber@trash.net>
Subject: Re: rtsp-conntrack compile failed on 2.6.16 kernel
Date: Mon, 23 Oct 2006 13:23:58 +0200
Message-ID: <453CA64E.9010102@trash.net>
References: <361646925.14969@eyou.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: wangbj@lzu.edu.cn
In-Reply-To: <361646925.14969@eyou.net>
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

Wang, Baojun wrote:
> hi, list:
> 
>   I have met some problems with rtsp-conntrack patch, kernel version is
> 2.6.16, patch with the svn version of patch-o-matic(./runme exra) and
> iptables, both revision are 6688. any ideas? thanks very much!
> 
> scripts/Makefile.build:51: kbuild: net/ipv4/netfilter/Makefile - Usage
> of export-objs is obsolete in 2.6. Please fix!

Looks like you somehow managed to apply the 2.4 version of the patch.
Most likely the 2.6 version won't work either, but it should be easier
to fix.
