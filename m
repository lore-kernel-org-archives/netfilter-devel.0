From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Packet Fragementation
Date: Wed, 31 Mar 2004 17:08:58 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403311708100.21410-100000@filer.marasystems.com>
References: <20040331140404.16955.qmail@web13907.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Scott MacKay <scottmackay@yahoo.com>
In-Reply-To: <20040331140404.16955.qmail@web13907.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 31 Mar 2004, Scott MacKay wrote:

> You are the god!!!! TY so much :)
> Actually, NF_IP_PRI_RAW is -300 (at least 2.4.25
> kernel patch) , so I am golden.

Just a copy-paste error on my part..

> Ah good.  So it sounds like I can add in my packet
> altering code in mangle/POST_ROUTING (where I have
> unfragmented packets ready to head out) and then my
> packet de-altering code in raw/PRE_ROUTING (where I
> will have de-fragmented packets that have not yet been
> examined for session/conn track yet) and I will be a
> Happy Camper.

>From what I can tell this should work yes.

Regards
Henrik
