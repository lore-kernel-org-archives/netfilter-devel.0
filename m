From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH RFC,net-next 1/3] ip_tunnel: add type field to struct
 ip_tunnel_info
Date: Thu, 4 Oct 2018 14:00:10 +0200
Message-ID: <31d90557-b7a4-7cdc-2ac6-acc574b2de69@iogearbox.net>
References: <20181004000345.2380-1-pablo@netfilter.org>
 <20181004000345.2380-2-pablo@netfilter.org>
 <81675bff-ec49-a40a-ffab-2c298b506154@iogearbox.net>
 <20181004105618.pugjxorqyuapwlzl@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        roopa@cumulusnetworks.com, amir@vadai.me, pshelar@ovn.org,
        u9012063@gmail.com, alexei.starovoitov@gmail.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181004105618.pugjxorqyuapwlzl@salvia>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 10/04/2018 12:56 PM, Pablo Neira Ayuso wrote:
> On Thu, Oct 04, 2018 at 11:25:33AM +0200, Daniel Borkmann wrote:
>> On 10/04/2018 02:03 AM, Pablo Neira Ayuso wrote:
[...]
>>> diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
>>> index a70097ecf33c..1ee2509534df 100644
>>> --- a/net/openvswitch/flow_netlink.c
>>> +++ b/net/openvswitch/flow_netlink.c
>>> @@ -2602,6 +2602,7 @@ static int validate_and_copy_set_tun(const struct nlattr *attr,
>>>  	ovs_tun->tun_dst = tun_dst;
>>>  
>>>  	tun_info = &tun_dst->u.tun_info;
>>> +	tun_info->type = IP_TUNNEL_TYPE_UNSPEC;
>>>  	tun_info->mode = IP_TUNNEL_INFO_TX;
>>>  	if (key.tun_proto == AF_INET6)
>>>  		tun_info->mode |= IP_TUNNEL_INFO_IPV6;
>>>
>>
>> If so then this should also be made explicit IP_TUNNEL_TYPE_UNSPEC in BPF code
>> since all these tunnel types are supported there as well.
> 
> Are you refering to proper initialization? I can see a memset() there
> for the ip_tunnel_info structure, which is implicitly setting
> tun_info->type to zero, ie. IP_TUNNEL_TYPE_UNSPEC.
> 
> I can also make it explicit there if you prefer.

Yeah that would be my preference as otherwise we might miss future changes there.

Thanks,
Daniel
