From: Lukas Ruf <ruf@rawip.org>
Subject: Re: printing packet data
Date: Wed, 22 Dec 2004 14:54:34 +0100
Message-ID: <20041222135434.GA12324@tik.ee.ethz.ch>
References: <72c6e37904122118504466dd28@mail.gmail.com>
Reply-To: PLEASE REPLY TO THE LIST <dev_null@rawip.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kernel Newbies <kernelnewbies@nl.linux.org>,
	netfilter development <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: linux lover <linux.lover2004@gmail.com>
Content-Disposition: inline
In-Reply-To: <72c6e37904122118504466dd28@mail.gmail.com>
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

> linux lover <linux.lover2004@gmail.com> [2004-12-22 13:54]:
>
> But how can i print those HEX codes in packet?  regards, linux.lover

simply make use of printk() and print the content of the packet.

wbr,
Lukas
-- 
Lukas Ruf           | Wanna know anything about raw |
<http://www.lpr.ch> | IP? -> <http://www.rawip.org> |
eMail Style Guide: <http://www.rawip.org/style.html>|
