From: Jonathan G - Mailing Lists <email-lists@surestorm.com>
Subject: Re: [nf-failover] [RFC] ct_sync 0.15
Date: Fri, 13 Aug 2004 20:07:51 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <411D0377.20009@surestorm.com>
References: <1092404121.2402.67.camel@nienna.balabit> <411CC99C.7020205@surestorm.com> <20040813173558.GA415@sch.bme.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter-failover list <netfilter-failover@lists.netfilter.org>,
 netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: KOVACS Krisztian <hidden@sch.bme.hu>
In-Reply-To: <20040813173558.GA415@sch.bme.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

OK Krisztian, as i said on Tuesday i will start patching the kernel and 
i will be in contact.

;-)
BR,

jonathan


KOVACS Krisztian wrote:
>   Hi,
> 
> On Fri, Aug 13, 2004 at 04:01:00PM +0200, Jonathan G - Mailing Lists wrote:
> 
>>   my partner and me are preparing for the next week a firewall/High 
>>Availability/Load Balancer cluster made of the following software:
>>
>>- Security: IPTables 1.2.8
>>- HA: KeepAlived (only the VRRPv2 part)
>>- LB: Pen (siag.nu/pen) for tcp connections
>>
>>
>>We would be so pleased and interested in test you package and discuss a 
>>real wold implementation (the installation of this cluster (2 nodes) is 
>>for an ISP).
> 
> 
>   Wow, great. Primarily I would like if you could do some testing. I
> don't think ct_sync is production-ready, but definitely needs testing in
> as many different environments as possible. So, if you have some extra
> time and could give ct_sync a test run, I'd be really happy.
> 
> 
>>Drop me an email to tell how start and we will help all of us get more 
>>real results with our system.
> 
> 
>   Hmmm, in theory all you have to do is check out the netfilter-ha
> repository from CVS, and all instructions should be given in the README
> file there. (Probably the most problematic part is getting the patches
> applied to your kernel. If you have problems doing so, I'll happily help
> with creating an aggregated patch.)
> 
>   To check out the tree, use:
> $ cvs -d :pserver:cvs:cvs@pserver.netfilter.org:/cvspublic co netfilter-ha
> 

-- 
   :::: Jonathan Gonzalez Fernandez ::::

    (o>  mail  : jonathan@surestorm.com
    //\  jabber: surestorm@jabber.org
    V_/  site  : www.surestorm.com

   ::: Registered Linux User #333386 :::
