From: Xin Long <lucien.xin@gmail.com>
Subject: Re: [PATCH net] ipvs: call ip_vs_dst_notifier before ipv6_dev_notf
Date: Thu, 15 Nov 2018 00:08:45 +0900
Message-ID: <CADvbK_eEjoDj990eQUWJYCM=+LhEMFucVZRB305q70pQK6SVVQ@mail.gmail.com>
References: <4bfc74f2a94e3721afd5ee4dd3cb60f8e4b68c7c.1542129933.git.lucien.xin@gmail.com>
 <201811141232.H4SG8SzP%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: kbuild-all@01.org, network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, davem <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Hans Schillstrom <hans@schillstrom.com>
To: kbuild test robot <lkp@intel.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <201811141232.H4SG8SzP%fengguang.wu@intel.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Nov 14, 2018 at 1:38 PM kbuild test robot <lkp@intel.com> wrote:
>
> Hi Xin,
>
> Thank you for the patch! Yet something to improve:
>
> [auto build test ERROR on net/master]
>
> url:    https://github.com/0day-ci/linux/commits/Xin-Long/ipvs-call-ip_vs_dst_notifier-before-ipv6_dev_notf/20181114-055727
> config: i386-randconfig-x005-11131818 (attached as .config)
> compiler: gcc-7 (Debian 7.3.0-1) 7.3.0
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386
>
> All errors (new ones prefixed by >>):
>
> >> net/netfilter/ipvs/ip_vs_ctl.c:3983:14: error: 'ADDRCONF_NOTIFY_PRIORITY' undeclared here (not in a function); did you mean 'DEVCONF_NDISC_NOTIFY'?
>      .priority = ADDRCONF_NOTIFY_PRIORITY + 5,
>                  ^~~~~~~~~~~~~~~~~~~~~~~~
>                  DEVCONF_NDISC_NOTIFY
>
> vim +3983 net/netfilter/ipvs/ip_vs_ctl.c
>
>   3980
>   3981  static struct notifier_block ip_vs_dst_notifier = {
>   3982          .notifier_call = ip_vs_dst_event,
> > 3983          .priority = ADDRCONF_NOTIFY_PRIORITY + 5,
>   3984  };
>   3985
This issue only exist on ipv6, I will fix it by simply using
#ifdef CONFIG_IP_VS_IPV6

>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
