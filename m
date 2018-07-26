From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH RFC/RFT net-next 00/17] net: Convert neighbor tables to
 per-namespace
Date: Thu, 26 Jul 2018 11:12:34 +0000
Message-ID: <be5c3f5be49e4e22bf1160a1d6d3a1b0@AcuMS.aculab.com>
References: <1a3f59a9-0ba5-c83f-16a6-f9550a84f693@gmail.com>
        <CAM_iQpWabZorkMNswyfHyS4KT=f_bgMtK8K35=84uah6Kfqxew@mail.gmail.com>
        <1a27e301-3275-b349-a2f8-afdfdc02f04f@gmail.com>
        <20180718.125938.2271502580775162784.davem@davemloft.net>
        <28c30574-391c-b4bd-c337-51d3040d901a@gmail.com>
        <CAM_iQpW4-JkZY7jXx0Q1b907hQ85UOL1eXv2YHwSukb5L=apUg@mail.gmail.com>
        <5021d874-8e99-6eba-f24b-4257c62d4457@gmail.com>
        <CAM_iQpUc-H2kZCBevePs6g-8qKyJkUhdd1ZDSQgYsCG0ChfC2w@mail.gmail.com>
        <87muufze8w.fsf@xmission.com>
        <4b03b5f6-87ce-9ff2-7c14-598beebd8fb8@gmail.com>
 <87zhyfw70m.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Cc: Cong Wang <xiyou.wangcong@gmail.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "nikita.leshchenko@oracle.com" <nikita.leshchenko@oracle.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "Saeed Mahameed" <saeedm@mellanox.com>,
        Alexander Aring <alex.aring@gmail.com>,
        "linux-wpan@vger.kernel.org" <linux-wpan@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
To: "'Eric W. Biederman'" <ebiederm@xmission.com>,
        David Ahern <dsahern@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <87zhyfw70m.fsf@xmission.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Eric W. Biederman
> Sent: 25 July 2018 18:38
...
> >> Further unless I misread something you are increasing the number of
> >> timers to 3 per namespace.  If I create create a thousand network
> >> namespaces that feels like it will hurt system performance overall.
> >
> > It seems to me the timers are per neighbor entry not table. The per
> > table ones are for proxies.
> 
> It seems I misread that bit when I was refreshing my memory on what
> everything is doing.  If we can already have 1024 timers that makes
> timers not a concern.

Surely it is enough to just have a timestamp in each entry.
Deletion of expired items need not be done until insert (which
has the table suitable locked) bumps into an expired item.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
