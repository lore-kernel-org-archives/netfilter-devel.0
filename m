From: Maik Hentsche <netfilter@mm-double.de>
Subject: Re: Launch script when packet is received
Date: Tue, 06 Mar 2007 14:12:04 +0100
Message-ID: <20070306141204.j93021i5r0g0080g@webmail.df.eu>
References: <1173135814.45eca1c605b17@webmail.alinto.com>
	<45ED6444.7020803@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45ED6444.7020803@ufomechanic.net>
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

Zitat von Amin Azez <azez@ufomechanic.net>:

> Or you could use the depracated ULOG v1 target which receives packets
> over netlink and hack the ulog daemon to do your bidding launching scripts.

Or you can use specter for the same deprecated ULOG target because  
this daemon already has a "call a script" module (among other  
improvements over ulogd). Unfortunatelly I do not know of any efforts  
to make specter use libnfnetlink.

so long
Maik
