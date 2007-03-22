From: Patrick McHardy <kaber@trash.net>
Subject: Re: NFNL_NFA_NEST
Date: Thu, 22 Mar 2007 18:01:27 +0100
Message-ID: <4602B667.2030304@trash.net>
References: <4600BDBB.8020205@trash.net> <4601B796.5030100@netfilter.org>
	<460261EB.4000402@trash.net> <46028242.4090609@netfilter.org>
	<460284D4.30709@trash.net> <4602B25B.10909@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4602B25B.10909@netfilter.org>
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

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
> 
>>Not really. The NEST bit allows to walk nested structures without
>>being aware of the structure. So all you need to do is make it aware
>>of which attributes are nested - something you need anyway for
>>parsing I suppose.
> 
> 
> OK, then I have two choices here, define a proxy function that is
> structure aware to convert TL to network byte order that will be almost
> a copy and paste of the parsing part, or alternatively integrate the
> byte order conversion as an option for the build/parse functions, as for
> now the latter seems more natural to me.


I guess it should be possible to define a couple of structures that
hold the information about which attributes are nested and build a
simple conversion function based on that.

>>Yes, we should probably wait for at least one year.
> 
> 
> Fine with it. I'm about to release a new version of libnfnetlink, should
> we stop sending the nested bit thing to kernel since now?


Yes, the kernel doesn't need them in any case. Which gives me an
idea, we could just stop sending them in userspace and still
include them in the kernel, if that makes life easier for you.
