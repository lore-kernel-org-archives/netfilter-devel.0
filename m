From: Patrick McHardy <kaber@trash.net>
Subject: Re: 2.6.17.1 compile error with a netfilter module
Date: Mon, 03 Jul 2006 20:26:36 +0200
Message-ID: <44A9615C.2050405@trash.net>
References: <925A849792280C4E80C5461017A4B8A206F784@mail733.InfraSupportEtc.com>
	<1151700888.2709.4.camel@murdegern.hindenburgdamm.example>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Greg Scott <GregScott@InfraSupportEtc.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Torsten Luettgert <t.luettgert@pressestimmen.de>
In-Reply-To: <1151700888.2709.4.camel@murdegern.hindenburgdamm.example>
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

Torsten Luettgert wrote:
> On Fri, 2006-06-30 at 12:36 -0500, Greg Scott wrote:
> 
>>Hmmm -
> 
> 
>>I'll try another build, this time with 2.6.17.2 and POM 20060629 using
>>these POM 
>>modules:
>>  time
>>  ipp2p
>>  ROUTE
>>  sip-conntrack-nat
> 
> 
> time, ipp2p and ROUTE won't work with 2.6.17 without API patches -
> I posted those last saturday, but they didn't get committed yet.
> You can grab them from the archives. Don't know about sip-conntrack-nat,
> but I suspect it'll have the same problem.

Just applied ROUTE and u32. I think Jozsef already fixed u32, the
remaining patchlets are not part of official pomng anymore, although
I still haven't received the URL of the new external repository.
