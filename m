From: "Nikolai Dahlem" <listuser@epygi.de>
Subject: RE: NAT problem with related connections
Date: Tue, 4 Nov 2003 14:41:59 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <DAELKAPIKOFAFFKELNHOCEAJCAAA.listuser@epygi.de>
References: <20031103153941.GF5081@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Harald Welte" <laforge@netfilter.org>
In-Reply-To: <20031103153941.GF5081@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, Nov 03, 2003 at 01:28:29PM +0100, Nikolai Dahlem wrote:
>> -----Original Message-----
>> From: Harald Welte [mailto:laforge@netfilter.org]
>> Sent: Montag, 3. November 2003 12:08
>> To: Nikolai Dahlem
>> Cc: Netfilter Development Mailinglist
>> Subject: Re: NAT problem with related connections
>>
>> On Mon, Nov 03, 2003 at 11:15:40AM +0100, Nikolai Dahlem wrote:

>take the example of FTP (more common, and I already forgot most SIP
>relevant stuff):

>client: 1.2.3.4, firewall: 10.20.30.40, ftp-server: 9.9.9.9

>packet received: client -> server PORT 1,2,3,4,5,6
>	- conntrack helper raises expectation 9.9.9.9:any->1.2.3.4:(5<<16 & 6)
>	- nat helper alters packet payload to PORT 10,20,30,40,5,6
>	- nat helper alters expectation to 9.9.9.9:any->10.20.30.40:(5<<16 & 6)

Ok, this is understood. Sorry, if I didn't describe my problem properly.

What I got is :

client 1.2.3.4, firewall: 10.20.30.40, ext. client: 9.9.9.9 (simplified, no
SIP-server)
client:INIVTE message 1.2.3.4:5000 -> ext.client
ext.client: OK message 9.9.9.9:6000 -> client
conntrack raises the correct expectations and all
client 1.2.3.4:5000 via firewall (changes sport to 1024) -> ext.client
9999:6000
ext.client 9.9.9.9:6000 via firewall -> client 1.2.3.4:5000
connection tracking doesn't see a connection, because the firewall changed
the sport to 1024,
but ext.client is answering to 6000.

So what do you think of raising the expectation after the INVITE packet,
instead of after the OK packet.
This way I'd be able to rewrite to the correct port,  but at this moment
there is no info about the ext.client,
so what should I enter in the expect-tuple ?


kind regards

Nikolai Dahlem
