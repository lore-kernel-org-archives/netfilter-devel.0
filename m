From: Amin Azez <azez@ufomechanic.net>
Subject: Re: ctnetlink attributes [was: Re: [PATCH 1/2] updates for
 [nf|ct]netlink and event API]
Date: Tue, 12 Jul 2005 09:18:37 +0100
Message-ID: <42D37CDD.5020007@ufomechanic.net>
References: <42C03F2E.30706@eurodev.net> <42C0806E.3010400@trash.net>
	<20050628071308.GE13239@sunbeam.de.gnumonks.org>
	<42C1747A.3010703@trash.net> <42C2F2DF.7070301@eurodev.net>
	<42C2FC14.80609@trash.net> <42C33E33.7090908@eurodev.net>
	<42C34445.9020709@trash.net> <42C426B2.6030907@eurodev.net>
	<42D29EC0.9050707@ufomechanic.net>
	<20050711171023.GG16728@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050711171023.GG16728@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:

>On Mon, Jul 11, 2005 at 05:30:56PM +0100, Amin Azez wrote:
>  
>
>>I'm interested in adding MAC addr attributes and CTA_TUPLE_MAC; not just
>>because of my fixation with MAC addresses but also to use conntrack to
>>record flow data for non IP-related protocols.
>>    
>>
>
>ctnetlink MAC attributes are IMHO nonsense because there is no mac
>address tracking in conntrack.
>  
>
Indeed; I was proposing that it be so, I'm currently maintaining
conntrack patches where mac addresses are part of the conntrack.

>>I realise it is not the current intent of conntrack to do this, but as
>>much as conntrack solves the high-load problems of ulog, it is desirable
>>for it to keep counters for non-ip protocols.
>>    
>>
>
>Also, MAC address tracking doesn't really make sense since as an
>intermediate router there is no way that the assumption "source and
>destination mac never change" is ever valid.
>  
>
This is also true, there are few circumstances that the mac address
could change within the life of a connection and maintain the
connection, and it is uncertain in the scenario I proposed how this
should be handled.

>>As fast as protocol handlers can be devised it will become "conntrack"
>>again instead of "flowtrack", but the universal identifier between hosts
>>involved in a connection is the mac address and protocol. 
>>    
>>
>
>no.  you always only see the next hop mac address.  let's say you have
>an upsteram and a downstream router, then all your 'connections' would
>be between the same two mac addresses.
>  
>
The use would be limited to switched or transparently bridged networks
which is where most non-ip trafffic will be kept. I don't think this
particularly limits the use; many protocols do not employ a global
address space anyway.

SPX protocol uses the MAC address in conjunction with a network number
for node addressing.

>>The question is, how do others feel about conntrack tracking non-ip
>>connections? I intend to provide patches to do this if it is welcome.
>>    
>>
>
>nf_conntrack goes the way to layer-3-independent connection tracking.
>However, conntrack will remain to happen at layer3 and 4 (with minor
>exceptions to higher layers in the case of conntrack helpers).
>  
>
So you are not against tracking non-IP traffic as such?
I agree that it is ideal to break open the layer 3 addressing for use in
the conntrack tuple, I was suggesting using mac address and protocol as
a fallback when this was not available.

Amin
