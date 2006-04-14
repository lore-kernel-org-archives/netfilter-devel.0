From: "Eric Leblond" <eric@inl.fr>
Subject: Re: Request help
Date: Fri, 14 Apr 2006 14:10:22 +0200 (CEST)
Message-ID: <60616.194.167.18.244.1145016622.squirrel@mail.inl.fr>
References: <op.s7zqwjz4extast@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <op.s7zqwjz4extast@localhost.localdomain>
To: "Paolo Cerrito" <paolo.cerrito@tin.it>
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

> Hy,
> my name is paolo, i have to develop an application who extracts packets
>  from netfilter_queue, using netlink, process the packets and reinject
> packets.
> Can onyone help me, on where i can find api references for
> netfilter_queue?

You can find beta man pages here :
http://archives.free.net.ph/message/20060208.171235.186dce08.en.html

> Or how i can i do?

For usage example, you can have a look at the NuFW project :
     http://www.nufw.org/
Code under src/nufw is the interesting part.

BR,
--
Eric Leblond
