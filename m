From: Patrick McHardy <kaber@trash.net>
Subject: Re: policy routing on locally generated packets
Date: Tue, 26 Aug 2003 15:17:10 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F4B5DD6.7080503@trash.net>
References: <1061813400.1289.36.camel@drs0.manchotnetworks.net>	<3F4A01BE.1090805@trash.net> <3F4A2795.3030805@trash.net>	<1061837608.1333.9.camel@drs0.manchotnetworks.net> 	<20030825190750.GH423@oknodo.bof.de> <1061887675.1273.37.camel@drs0.manchotnetworks.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Patrick Schaaf <bof@bof.de>,
 netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "lartc@manchotnetworks.net" <lartc@manchotnetworks.net>
In-Reply-To: <1061887675.1273.37.camel@drs0.manchotnetworks.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

lartc@manchotnetworks.net wrote:

>My issue arises from ip accounting -- that is -- each user on a linux
>box must have their wire traffic accounted for. As in the first message
>of the thread:
>

Why don't add routes without specifing a source and nat the packets
to the prefered address ? Also, for accounting purposes the byte counters
of the matching rule should be fine i would think .. ?

Bye
Patrick
