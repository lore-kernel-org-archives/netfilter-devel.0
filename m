From: Herve Eychenne <rv@wallfire.org>
Subject: Re: buckets-byte per conntrack
Date: Mon, 27 Jun 2005 17:10:27 +0200
Message-ID: <20050627151027.GI4225@eychenne.org>
References: <29003954.1119882475361.JavaMail.ngmail@webmail-07.arcor-online.net>
Reply-To: rv@eychenne.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: thomasmkling@arcor.de
Content-Disposition: inline
In-Reply-To: <29003954.1119882475361.JavaMail.ngmail@webmail-07.arcor-online.net>
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

On Mon, Jun 27, 2005 at 04:27:55PM +0200, thomasmkling@arcor.de wrote:

> ip_conntrack version 2.1 (214 buckets, 1712 max) - 208 bytes per conntrack

> I searched the archive and didn't find a detailed explanation for these values, can someone please help me?

> 208 bytes per conntrack:
> i guess that means that 208 bytes are used for managing ip, ports,state, connection-lifetime, tcp-option,seq-numbers,... (can I see how many bytes for which values used?)

> when are the 208 bytes consumed? I started 100 tcp-server-sockets and lost 100*330 bytes free_memory (vmstat). Then I build a new kernel without connection tracking and i got exactly the same memory-usage. why, I expected lower memory-usage without ip_conntrack?

> 1712 max:
> means that I can only track 1712 connections? what happens if i have more, are they denied, invalid, not logged?
> if i match on ESTABLISHED and have more than 1712 connections, what then?
> how can i have more max?

> 214 buckets:
> nothing found, what's that?

I wrote a little document that might partially answer your questions:
http://www.wallfire.org/misc/netfilter_conntrack_perf.txt

 Herve

-- 
 _
(°=  Hervé Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
