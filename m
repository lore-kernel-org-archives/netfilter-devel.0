From: Pablo Neira <pablo@eurodev.net>
Subject: Re: Packet checksum
Date: Wed, 04 Feb 2004 14:25:25 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4020F2C5.6030805@eurodev.net>
References: <20040204125829.59444.qmail@web13906.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Scott MacKay <scottmackay@yahoo.com>,
	netfilter-devel@lists.netfilter.org
In-Reply-To: <20040204125829.59444.qmail@web13906.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Scott,

Scott MacKay wrote:

>When, in the great scheme of things, does packet
>checksum (and potential packet drop for bad checksums)
>occur?  Is there a particular point in the netfilter
>process or does it occur before/after the chains?
>  
>
AFAIK, the ip header checksum is done before the packet gets the 
NF_PREROUTING hook,
so the packet will be drop before it hits netfilter.

Have a look at the ip_rcv(...) function 
(http://lxr.linux.no/source/net/ipv4/ip_input.c#L418)

could anyone confirm this?

cheers,
Pablo
