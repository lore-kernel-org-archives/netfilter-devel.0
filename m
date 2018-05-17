From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH ghak81 V3 3/3] audit: collect audit task parameters
Date: Thu, 17 May 2018 09:43:16 +0800
Message-ID: <201805170921.vSuTk8UB%fengguang.wu@intel.com>
References: <fbed63483b5206009ee43ae889b30d43051f386c.1526430313.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="AqsLC8rIMeq19msA"
Cc: kbuild-all@01.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux NetDev Upstream Mailing List <netdev@vger.kernel.org>,
        Netfilter Devel List <netfilter-devel@vger.kernel.org>,
        Linux Security Module list
        <linux-security-module@vger.kernel.org>,
        Integrity Measurement Architecture
        <linux-integrity@vger.kernel.org>,
        SElinux list <selinux@tycho.nsa.gov>,
        Eric Paris <eparis@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Steve Grubb <sgrubb@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Richard Guy Briggs <rgb@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <fbed63483b5206009ee43ae889b30d43051f386c.1526430313.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Richard,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on next-20180516]
[cannot apply to linus/master tip/sched/core v4.17-rc5 v4.17-rc4 v4.17-rc3 v4.17-rc5]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Richard-Guy-Briggs/audit-group-task-params/20180517-090703
config: i386-tinyconfig (attached as .config)
compiler: gcc-7 (Debian 7.3.0-16) 7.3.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All errors (new ones prefixed by >>):

   kernel/fork.c: In function 'copy_process':
>> kernel/fork.c:1739:3: error: 'struct task_struct' has no member named 'audit'
     p->audit = NULL;
      ^~

vim +1739 kernel/fork.c

  1728	
  1729		p->default_timer_slack_ns = current->timer_slack_ns;
  1730	
  1731		task_io_accounting_init(&p->ioac);
  1732		acct_clear_integrals(p);
  1733	
  1734		posix_cpu_timers_init(p);
  1735	
  1736		p->start_time = ktime_get_ns();
  1737		p->real_start_time = ktime_get_boot_ns();
  1738		p->io_context = NULL;
> 1739		p->audit = NULL;
  1740		cgroup_fork(p);
  1741	#ifdef CONFIG_NUMA
  1742		p->mempolicy = mpol_dup(p->mempolicy);
  1743		if (IS_ERR(p->mempolicy)) {
  1744			retval = PTR_ERR(p->mempolicy);
  1745			p->mempolicy = NULL;
  1746			goto bad_fork_cleanup_threadgroup_lock;
  1747		}
  1748	#endif
  1749	#ifdef CONFIG_CPUSETS
  1750		p->cpuset_mem_spread_rotor = NUMA_NO_NODE;
  1751		p->cpuset_slab_spread_rotor = NUMA_NO_NODE;
  1752		seqcount_init(&p->mems_allowed_seq);
  1753	#endif
  1754	#ifdef CONFIG_TRACE_IRQFLAGS
  1755		p->irq_events = 0;
  1756		p->hardirqs_enabled = 0;
  1757		p->hardirq_enable_ip = 0;
  1758		p->hardirq_enable_event = 0;
  1759		p->hardirq_disable_ip = _THIS_IP_;
  1760		p->hardirq_disable_event = 0;
  1761		p->softirqs_enabled = 1;
  1762		p->softirq_enable_ip = _THIS_IP_;
  1763		p->softirq_enable_event = 0;
  1764		p->softirq_disable_ip = 0;
  1765		p->softirq_disable_event = 0;
  1766		p->hardirq_context = 0;
  1767		p->softirq_context = 0;
  1768	#endif
  1769	
  1770		p->pagefault_disabled = 0;
  1771	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--AqsLC8rIMeq19msA
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
R+Y/92GcCFNYAAA=

--AqsLC8rIMeq19msA--
