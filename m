From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Future of CONNMARK (was Re: MASQUERADE: Route sent us somewhere
 else (was Re: Fw: Rusty's brain broke!)
Date: Sun, 18 Jan 2004 00:40:39 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401180032050.11958-100000@filer.marasystems.com>
References: <200401171046.02062.teastep@shorewall.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>, Julian Anastasov <ja@ssi.bg>,
   <linux-net@vger.kernel.org>,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Tom Eastep <teastep@shorewall.net>
In-Reply-To: <200401171046.02062.teastep@shorewall.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 17 Jan 2004, Tom Eastep wrote:

> I am very much in favor of the change you propose. The ability to set 
> individual bits would allow Netfilter configuration tools like Shorewall to 
> make internal use of packet marking by reserving part of the mark field for 
> use by the tool and the remainder of the field for use by the user.
> 
> Given that the current MARK target lacks this capability, I am not able to 
> make effective use of that target in Shorewall.

Please note that we are talkning about the CONNMARK target which is quite 
different from MARK. The two operates on different values. The discussed 
change will NOT add mask operations to the standard MARK target.

If you need mask operations in the standard MARK target then nothing stops
you from writing an extended MARK target having mask operations. It is
just that it can not be done easily in the standard kernel due to binary
compatibility issues.

Why there is not a extra class p-o-m patch to add mask capability to MARK 
I do not know. I am pretty sure the netfilter team would not mind if such 
patch is submitted, but as indicated above it can not progress beyond 
"extra" due to the frozen nature of the existing MARK target, at least not 
unless a different target name is used.

It is a pity the iptables match/target interface does not have versioning 
support of the target/match structures. Maybe 2.7 will..

Regards
Henrik
