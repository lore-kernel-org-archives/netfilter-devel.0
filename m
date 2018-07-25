From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH RFC/RFT net-next 00/17] net: Convert neighbor tables to
 per-namespace
Date: Wed, 25 Jul 2018 12:13:30 -0600
Message-ID: <dacc9322-fd5a-dfeb-e4f1-7a288fb79886@gmail.com>
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
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Cong Wang <xiyou.wangcong@gmail.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        nikita.leshchenko@oracle.com,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Alexander Aring <alex.aring@gmail.com>,
        linux-wpan@vger.kernel.org,
        NetFilter <netfilter-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87zhyfw70m.fsf@xmission.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 7/25/18 11:38 AM, Eric W. Biederman wrote:
> 
> Absolutely NOT.  Global thresholds are exactly correct given the fact
> you are running on a single kernel.
> 
> Memory is not free (Even though we are swimming in enough of it memory
> rarely matters).  One of the few remaining challenges is for containers
> is finding was to limit resources in such a way that one application
> does not mess things up for another container during ordinary usage.
> 
> It looks like the neighbour tables absolutely are that kind of problem,
> because the artificial limits are too strict.   Completely giving up on
> limits does not seem right approach either.  We need to fix the limits
> we have (perhaps making them go away entirely), not just apply a
> band-aid.  Let's get to the bottom of this and make the system better.

Eric: yes, they all share the global resource of memory and there should
be limits on how many entries a remote entity can create.

Network namespaces can provide a separation such that one namespace does
not disrupt networking in another. It is absolutely appropriate to do
so. Your rigid stance is inconsistent given the basic meaning of a
network namespace and the parallels to this same problem -- bridges,
vxlans, and ip fragments. Only neighbor tables are not per-device or per
namespace; your insistence on global limits is missing the mark and wrong.
