From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH RFC/RFT net-next 00/17] net: Convert neighbor tables to
 per-namespace
Date: Thu, 19 Jul 2018 10:16:36 -0600
Message-ID: <28c30574-391c-b4bd-c337-51d3040d901a@gmail.com>
References: <1a3f59a9-0ba5-c83f-16a6-f9550a84f693@gmail.com>
 <CAM_iQpWabZorkMNswyfHyS4KT=f_bgMtK8K35=84uah6Kfqxew@mail.gmail.com>
 <1a27e301-3275-b349-a2f8-afdfdc02f04f@gmail.com>
 <20180718.125938.2271502580775162784.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: xiyou.wangcong@gmail.com, netdev@vger.kernel.org,
        nikita.leshchenko@oracle.com, roopa@cumulusnetworks.com,
        stephen@networkplumber.org, idosch@mellanox.com, jiri@mellanox.com,
        saeedm@mellanox.com, alex.aring@gmail.com,
        linux-wpan@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180718.125938.2271502580775162784.davem@davemloft.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 7/17/18 9:59 PM, David Miller wrote:
> From: David Ahern <dsahern@gmail.com>
> Date: Tue, 17 Jul 2018 13:02:18 -0600
> 
>> I understand the concern about global resource and limits: as it stands
>> you have to increase the limits in init_net to the max expected and hope
>> for the best. With per namespace limits you can lower the limits of each
>> namespace better control the total impact on the total memory used.
>> Perhaps the defaults for namespaces after init_net could have really low
>> defaults (e.g., 16 / 32 / 64 for gc_thresh 1/2/3) requiring admin
>> intervention.
> 
> How does this work when a namespace creates another namespace?
> 
> Changing the defaults for non-init_net namespaces could work, but that
> could be a surprise to some people.
> 

Patches 14 (ipv4) and 15 (ipv6) currently use the existing hardcoded
values - not based on current init_net or anything else. This could be
changed to:

+	if (net_eq(net, &init_net)) {
+		arp_tbl->gc_thresh1	= 128;
+		arp_tbl->gc_thresh2	= 512;
+		arp_tbl->gc_thresh3	= 1024;
+	} else {
+		arp_tbl->gc_thresh1	= 16;
+		arp_tbl->gc_thresh2	= 32;
+		arp_tbl->gc_thresh3	= 64;
+	}

and update the documentation that any new network namespaces have lower
defaults.

As for any change in behavior: today neighbor entries from one namespace
can be removed due to actions in another so no obvious correlation. With
lower settings then gc could kick in and remove entries that otherwise
would not have been. The big hit would be to a new namespace where an
app inserts a lot of PERMANENT entries.

Chatting with Nikolay about this and he brought up a good corollary - ip
fragmentation. It really is a similar problem in that memory is consumed
as a result of packets received from an external entity. The ipfrag
sysctls are per namespace with a limit that non-init_net namespaces can
not set high_thresh > the current value of init_net. Potential memory
consumed by fragments scales with the number of namespaces which is the
primary concern with making neighbor tables per namespace.

If we kept the current default settings (128/512/1024) per namespace we
still have capped memory use, and the one user visible hit that comes to
mind is the namespace with a lot of PERM entries.
