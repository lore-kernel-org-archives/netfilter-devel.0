From: Christian Brauner <christian@brauner.io>
Subject: [PATCH net-next 0/2] br_netfilter: enable in non-initial netns
Date: Wed,  7 Nov 2018 14:48:57 +0100
Message-ID: <20181107134859.19896-1-christian@brauner.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: tyhicks@canonical.com, pablo@netfilter.org,
        kadlec@blackhole.kfki.hu, fw@strlen.de, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com,
        Christian Brauner <christian@brauner.io>
To: davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, bridge@lists.linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hey everyone,

Over time I have seen multiple reports by users who want to run applications
(Kubernetes e.g. via [1]) that require the br_netfilter module in
non-initial network namespaces [2], [3], [4], [5] (There are more issues
where this requirement is reported.).
Currently, the /proc/sys/net/bridge folder is only created in the
initial network namespace. This patch series ensures that the
/proc/sys/net/bridge folder is available in each network namespace if
the module is loaded and disappears from all network namespaces when the
module is unloaded.
The patch series also makes the sysctls:

bridge-nf-call-arptables
bridge-nf-call-ip6tables
bridge-nf-call-iptables
bridge-nf-filter-pppoe-tagged
bridge-nf-filter-vlan-tagged
bridge-nf-pass-vlan-input-dev

apply per network namespace. This unblocks some use-cases where users
would like to e.g. not do bridge filtering for bridges in a specific
network namespace while doing so for bridges located in another network
namespace.
The netfilter rules are afaict already per network namespace so it
should be safe for users to specify whether a bridge device inside their
network namespace is supposed to go through iptables et al. or not.
Also, this can already be done by setting an option for each individual
bridge via Netlink. It should also be possible to do this for all
bridges in a network namespace via sysctls.

Thanks!
Christian

[1]: https://github.com/zimmertr/Bootstrap-Kubernetes-with-Ansible
[2]: https://github.com/lxc/lxd/issues/5193
[3]: https://discuss.linuxcontainers.org/t/bridge-nf-call-iptables-and-swap-error-on-lxd-with-kubeadm/2204
[4]: https://github.com/lxc/lxd/issues/3306
[5]: https://gitlab.com/gitlab-org/gitlab-runner/issues/3705

Christian Brauner (2):
  br_netfilter: add struct netns_brnf
  br_netfilter: namespace bridge netfilter sysctls

 include/net/net_namespace.h          |   3 +
 include/net/netfilter/br_netfilter.h |   3 +-
 include/net/netns/netfilter.h        |  16 +++
 net/bridge/br_netfilter_hooks.c      | 166 ++++++++++++++++++---------
 net/bridge/br_netfilter_ipv6.c       |   2 +-
 5 files changed, 134 insertions(+), 56 deletions(-)

-- 
2.19.1
