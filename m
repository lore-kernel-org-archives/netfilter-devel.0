From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH]: latest netfilter+ipsec patches
Date: Fri, 05 Mar 2004 03:00:07 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4047DF27.6090904@trash.net>
References: <20040128000938.GH11761@sunbeam.de.gnumonks.org> <401777B4.9020000@trash.net> <20040128103000.GP11761@sunbeam.de.gnumonks.org> <401D12B6.5030707@trash.net> <40301AB2.2030103@trash.net> <40337D63.6080602@trash.net> <20040218220337.GA3193@alpha.home.local> <40356624.6050209@trash.net> <4047AE0E.1080003@trash.net> <20040304231141.GA1782@alpha.home.local> <20040304234236.GB4995@samad.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Willy Tarreau <willy@w.ods.org>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
 Harald Welte <laforge@netfilter.org>, Tom Eastep <teastep@shorewall.net>,
 Michal Ludvig <mludvig@suse.cz>,
  guillaume@morinfr.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Alexander Samad <alex@samad.com.au>
In-Reply-To: <20040304234236.GB4995@samad.com.au>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Alexander Samad wrote:
> Q do I understand right that encrypted packets can or can't be acted
> upon by the hooks in LOCAL_IN.
> 
> Or another way of putting it does a packet travel the tables twice once
> as an encrypted packet and once as a de crypted packet ?

Exactly, input looks like this:

(encrypted) PRE_ROUTING -> LOCAL_IN ->
(plain) PRE_ROUTING -> LOCAL_IN/FORWARD

output looks like this:

(plain) FORWARD/LOCAL_OUT -> POST_ROUTING ->
(encrypted) LOCAL_OUT -> POST_ROUTING

This is the same as with freeswan, only without the ipsec
devices, the policy match can be used as a easy replacement
for them (-m policy --pol ipsec).

Regards,
Patrick

> 
> Alex
> 
> 
