From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next,RFC 00/13] New fast forwarding path
Date: Thu, 14 Jun 2018 11:14:37 -0700
Message-ID: <66634ba7-3d72-644a-9d26-d9644c540619@gmail.com>
References: <20180614141947.3580-1-pablo@netfilter.org>
 <20180614.101831.465275975690050595.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com
To: David Miller <davem@davemloft.net>, pablo@netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180614.101831.465275975690050595.davem@davemloft.net>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org



On 06/14/2018 10:18 AM, David Miller wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> Date: Thu, 14 Jun 2018 16:19:34 +0200
> 
>> This patchset proposes a new fast forwarding path infrastructure
>> that combines the GRO/GSO and the flowtable infrastructures. The
>> idea is to add a hook at the GRO layer that is invoked before the
>> standard GRO protocol offloads. This allows us to build custom
>> packet chains that we can quickly pass in one go to the neighbour
>> layer to define fast forwarding path for flows.
> 
> We have full, complete, customizability of the packet path via XDP
> and eBPF.
> 
> XDP and eBPF supports everything necessary to accomplish that,
> there are implementations of forwarding implementations in
> the tree and elsewhere.
> 
> And most importantly, XDP and eBPF are optimized in drivers and
> offloaded to hardware.
> 
> There really is no need for something like what you are proposing.
> 

I see one possible upside to that approach here which is the low end
MIPS/ARM/PowerPC 32-bit based routers that do not have an eBPF JIT
available (that's only MIPS32 and PowerPC AFAICT), it would be great to
see what happens on those systems and if we do get any performance
improvements for a traditional forwarding/routing workload. On those
platforms there are a number of things that just literally kill the
routing performance: small I and D caches, small or not L2, limited
bandwidth DRAM, huge call depths, big struct sk_buff layout, you name it.
-- 
Florian
