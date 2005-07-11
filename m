From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [OT] Re: rp_filtering
Date: Mon, 11 Jul 2005 20:18:38 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0507112017040.28946@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0507111946560.32325@yvahk01.tjqt.qr>
	<1121105149.5236.5.camel@anduril.intranet.cartel-securite.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Cedric Blancher <blancher@cartel-securite.fr>
In-Reply-To: <1121105149.5236.5.camel@anduril.intranet.cartel-securite.net>
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

>> That means someone could send a srcip=192.168.222.1 dstip=217.245.127.134 
>> packet to me on ippp0, could it? Or where is the verification...
>
>No, because you cannot use a Linux box own IP as source of a packet

Whoops, meant srcip=192.168.222.34

>received on any other interface than lo. If you do this, packet will be
>discarded.
>
>BTW, what's the relation with Netfilter ?

It's about filtering.
I probably need to add a filter rule for ippp0 to prevent this case.


Jan Engelhardt
-- 
