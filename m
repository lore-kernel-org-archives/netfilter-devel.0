From: Lennart Poettering <lennart@poettering.de>
Subject: Re: Develop a TCP P2P encrypt tool in Linux using netfilter?
Date: Sun, 1 Jun 2003 16:48:19 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030601144819.GA8769@seth.intheinter.net>
References: <002101c32847$74f10f10$6842f2da@dellxp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <002101c32847$74f10f10$6842f2da@dellxp>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 01.06.03 22:09, Yong Li (sdssly@sina.com) wrote:

>    Hello All,
>     
>    I want to develop a TCP packet encrypt tool in Linux. I need to modify
>    the receiving/sending TCP data. Can I use netfilter? if so, is there any
>    examples about the packet data modify?


Have a look on SEPPL:

http://www.ring2.org/seppl/

lp

-- 
name { Lennart Poettering } mail { lennart@poettering.de }
icq { 11060553 } www { http://www.poettering.de/lennart/ }
loc { hamburg, germany } pgp { 0x1A015CC4 } hack { .phi. }
