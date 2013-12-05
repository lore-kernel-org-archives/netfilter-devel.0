From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: libmnl [PATCH 2/5] examples: fix trivial error message
Date: Thu, 5 Dec 2013 19:16:24 +0900
Message-ID: <CAGCkEt1+dni9L0-5OYsPnoOhBZGB6XaRSQ9T_GKifSE4pwC_PQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qe0-f52.google.com ([209.85.128.52]:51496 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab3LEKQZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Dec 2013 05:16:25 -0500
Received: by mail-qe0-f52.google.com with SMTP id ne12so16897105qeb.25
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Dec 2013 02:16:24 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
Date: Thu, 7 Nov 2013 16:52:15 +0900
Subject: [PATCH 2/5] examples: fix trivial error message

---
 examples/genl/genl-family-get.c        |    2 +-
 examples/netfilter/nf-log.c            |   12 ++++++------
 examples/netfilter/nf-queue.c          |   14 +++++++-------
 examples/netfilter/nfct-create-batch.c |    4 ++--
 examples/netfilter/nfct-daemon.c       |    4 ++--
 examples/netfilter/nfct-dump.c         |    4 ++--
 examples/rtnl/rtnl-addr-dump.c         |    2 +-
 examples/rtnl/rtnl-link-dump.c         |    4 ++--
 examples/rtnl/rtnl-link-dump2.c        |    4 ++--
 examples/rtnl/rtnl-link-dump3.c        |    2 +-
 examples/rtnl/rtnl-link-event.c        |    2 +-
 examples/rtnl/rtnl-link-set.c          |    6 +++---
 examples/rtnl/rtnl-route-add.c         |    2 +-
 examples/rtnl/rtnl-route-dump.c        |    4 ++--
 examples/rtnl/rtnl-route-event.c       |    2 +-
 15 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/examples/genl/genl-family-get.c b/examples/genl/genl-family-get.c
index 50f7ea3..ba8de12 100644
--- a/examples/genl/genl-family-get.c
+++ b/examples/genl/genl-family-get.c
@@ -219,7 +219,7 @@ int main(int argc, char *argv[])
        portid = mnl_socket_get_portid(nl);

        if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
-               perror("mnl_socket_send");
+               perror("mnl_socket_sendto");
                exit(EXIT_FAILURE);
        }

diff --git a/examples/netfilter/nf-log.c b/examples/netfilter/nf-log.c
index a862912..901bd80 100644
--- a/examples/netfilter/nf-log.c
+++ b/examples/netfilter/nf-log.c
@@ -39,14 +39,14 @@ static int parse_attr_cb(const struct nlattr
*attr, void *data)
        case NFULA_TIMESTAMP:
                if (mnl_attr_validate2(attr, MNL_TYPE_UNSPEC,
                    sizeof(struct nfulnl_msg_packet_timestamp)) < 0) {
-                       perror("mnl_attr_validate");
+                       perror("mnl_attr_validate2");
                        return MNL_CB_ERROR;
                }
                break;
        case NFULA_HWADDR:
                if (mnl_attr_validate2(attr, MNL_TYPE_UNSPEC,
                    sizeof(struct nfulnl_msg_packet_hw)) < 0) {
-                       perror("mnl_attr_validate");
+                       perror("mnl_attr_validate2");
                        return MNL_CB_ERROR;
                }
                break;
@@ -174,28 +174,28 @@ int main(int argc, char *argv[])
        nlh = nflog_build_cfg_pf_request(buf, NFULNL_CFG_CMD_PF_UNBIND);

        if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
-               perror("mnl_socket_send");
+               perror("mnl_socket_sendto");
                exit(EXIT_FAILURE);
        }

        nlh = nflog_build_cfg_pf_request(buf, NFULNL_CFG_CMD_PF_BIND);

        if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
-               perror("mnl_socket_send");
+               perror("mnl_socket_sendto");
                exit(EXIT_FAILURE);
        }

        nlh = nflog_build_cfg_request(buf, NFULNL_CFG_CMD_BIND, qnum);

        if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
-               perror("mnl_socket_send");
+               perror("mnl_socket_sendto");
                exit(EXIT_FAILURE);
        }

        nlh = nflog_build_cfg_params(buf, NFULNL_COPY_PACKET, 0xFFFF, qnum);

        if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
-               perror("mnl_socket_send");
+               perror("mnl_socket_sendto");
                exit(EXIT_FAILURE);
        }

diff --git a/examples/netfilter/nf-queue.c b/examples/netfilter/nf-queue.c
index c66611f..6b7c30e 100644
--- a/examples/netfilter/nf-queue.c
+++ b/examples/netfilter/nf-queue.c
@@ -39,14 +39,14 @@ static int parse_attr_cb(const struct nlattr
*attr, void *data)
        case NFQA_TIMESTAMP:
                if (mnl_attr_validate2(attr, MNL_TYPE_UNSPEC,
                    sizeof(struct nfqnl_msg_packet_timestamp)) < 0) {
-                       perror("mnl_attr_validate");
+                       perror("mnl_attr_validate2");
                        return MNL_CB_ERROR;
                }
                break;
        case NFQA_HWADDR:
                if (mnl_attr_validate2(attr, MNL_TYPE_UNSPEC,
                    sizeof(struct nfqnl_msg_packet_hw)) < 0) {
-                       perror("mnl_attr_validate");
+                       perror("mnl_attr_validate2");
                        return MNL_CB_ERROR;
                }
                break;
@@ -188,28 +188,28 @@ int main(int argc, char *argv[])
        nlh = nfq_build_cfg_pf_request(buf, NFQNL_CFG_CMD_PF_UNBIND);

        if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
-               perror("mnl_socket_send");
+               perror("mnl_socket_sendto");
                exit(EXIT_FAILURE);
        }

        nlh = nfq_build_cfg_pf_request(buf, NFQNL_CFG_CMD_PF_BIND);

        if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
-               perror("mnl_socket_send");
+               perror("mnl_socket_sendto");
                exit(EXIT_FAILURE);
        }

        nlh = nfq_build_cfg_request(buf, NFQNL_CFG_CMD_BIND, queue_num);

        if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
-               perror("mnl_socket_send");
+               perror("mnl_socket_sendto");
                exit(EXIT_FAILURE);
        }

        nlh = nfq_build_cfg_params(buf, NFQNL_COPY_PACKET, 0xFFFF, queue_num);

        if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
-               perror("mnl_socket_send");
+               perror("mnl_socket_sendto");
                exit(EXIT_FAILURE);
        }

@@ -230,7 +230,7 @@ int main(int argc, char *argv[])
                id = ret - MNL_CB_OK;
                nlh = nfq_build_verdict(buf, id, queue_num, NF_ACCEPT);
                if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
-                       perror("mnl_socket_send");
+                       perror("mnl_socket_sendto");
                        exit(EXIT_FAILURE);
                }

diff --git a/examples/netfilter/nfct-create-batch.c
b/examples/netfilter/nfct-create-batch.c
index dd6623f..40cd2f6 100644
--- a/examples/netfilter/nfct-create-batch.c
+++ b/examples/netfilter/nfct-create-batch.c
@@ -87,7 +87,7 @@ send_batch(struct mnl_socket *nl, struct
mnl_nlmsg_batch *b, int portid)

        ret = mnl_socket_sendto(nl, mnl_nlmsg_batch_head(b), len);
        if (ret == -1) {
-               perror("mnl_socket_recvfrom");
+               perror("mnl_socket_sendto");
                exit(EXIT_FAILURE);
        }

@@ -116,7 +116,7 @@ send_batch(struct mnl_socket *nl, struct
mnl_nlmsg_batch *b, int portid)
                                  NULL, NULL, cb_ctl_array,
                                  MNL_ARRAY_SIZE(cb_ctl_array));
                if (ret == -1) {
-                       perror("mnl_cb_run");
+                       perror("mnl_cb_run2");
                        exit(EXIT_FAILURE);
                }

diff --git a/examples/netfilter/nfct-daemon.c b/examples/netfilter/nfct-daemon.c
index 5258537..a9b93db 100644
--- a/examples/netfilter/nfct-daemon.c
+++ b/examples/netfilter/nfct-daemon.c
@@ -87,7 +87,7 @@ static int parse_ip_cb(const struct nlattr *attr, void *data)
        case CTA_IP_V6_DST:
                if (mnl_attr_validate2(attr, MNL_TYPE_BINARY,
                                       sizeof(struct in6_addr)) < 0) {
-                       perror("mnl_attr_validate");
+                       perror("mnl_attr_validate2");
                        return MNL_CB_ERROR;
                }
                break;
@@ -322,7 +322,7 @@ int main(int argc, char *argv[])
                        /* ... request a fresh dump of the table from kernel */
                        ret = mnl_socket_sendto(nl, nlh, nlh->nlmsg_len);
                        if (ret == -1) {
-                               perror("mnl_socket_recvfrom");
+                               perror("mnl_socket_sendto");
                                return -1;
                        }
                        tv.tv_sec = secs;
diff --git a/examples/netfilter/nfct-dump.c b/examples/netfilter/nfct-dump.c
index ce05bbb..25ccf2c 100644
--- a/examples/netfilter/nfct-dump.c
+++ b/examples/netfilter/nfct-dump.c
@@ -66,7 +66,7 @@ static int parse_ip_cb(const struct nlattr *attr, void *data)
        case CTA_IP_V6_DST:
                if (mnl_attr_validate2(attr, MNL_TYPE_BINARY,
                                       sizeof(struct in6_addr)) < 0) {
-                       perror("mnl_attr_validate");
+                       perror("mnl_attr_validate2");
                        return MNL_CB_ERROR;
                }
                break;
@@ -292,7 +292,7 @@ int main(void)

        ret = mnl_socket_sendto(nl, nlh, nlh->nlmsg_len);
        if (ret == -1) {
-               perror("mnl_socket_recvfrom");
+               perror("mnl_socket_sendto");
                exit(EXIT_FAILURE);
        }
        portid = mnl_socket_get_portid(nl);
diff --git a/examples/rtnl/rtnl-addr-dump.c b/examples/rtnl/rtnl-addr-dump.c
index 156563b..6b4e52e 100644
--- a/examples/rtnl/rtnl-addr-dump.c
+++ b/examples/rtnl/rtnl-addr-dump.c
@@ -111,7 +111,7 @@ int main(int argc, char *argv[])
        portid = mnl_socket_get_portid(nl);

        if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
-               perror("mnl_socket_send");
+               perror("mnl_socket_sendto");
                exit(EXIT_FAILURE);
        }

diff --git a/examples/rtnl/rtnl-link-dump.c b/examples/rtnl/rtnl-link-dump.c
index f717cea..f5d6312 100644
--- a/examples/rtnl/rtnl-link-dump.c
+++ b/examples/rtnl/rtnl-link-dump.c
@@ -34,7 +34,7 @@ static int data_attr_cb(const struct nlattr *attr, void *data)
                break;
        case IFLA_IFNAME:
                if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0) {
-                       perror("mnl_attr_validate2");
+                       perror("mnl_attr_validate");
                        return MNL_CB_ERROR;
                }
                break;
@@ -108,7 +108,7 @@ int main(void)
        portid = mnl_socket_get_portid(nl);

        if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
-               perror("mnl_socket_send");
+               perror("mnl_socket_sendto");
                exit(EXIT_FAILURE);
        }

diff --git a/examples/rtnl/rtnl-link-dump2.c b/examples/rtnl/rtnl-link-dump2.c
index 78f31a8..b3ca3fa 100644
--- a/examples/rtnl/rtnl-link-dump2.c
+++ b/examples/rtnl/rtnl-link-dump2.c
@@ -25,7 +25,7 @@ static int data_attr_cb(const struct nlattr *attr, void *data)
                break;
        case IFLA_IFNAME:
                if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0) {
-                       perror("mnl_attr_validate2");
+                       perror("mnl_attr_validate");
                        return MNL_CB_ERROR;
                }
                printf("name=%s ", mnl_attr_get_str(attr));
@@ -81,7 +81,7 @@ int main(void)
        portid = mnl_socket_get_portid(nl);

        if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
-               perror("mnl_socket_send");
+               perror("mnl_socket_sendto");
                exit(EXIT_FAILURE);
        }

diff --git a/examples/rtnl/rtnl-link-dump3.c b/examples/rtnl/rtnl-link-dump3.c
index a6dce6f..2521214 100644
--- a/examples/rtnl/rtnl-link-dump3.c
+++ b/examples/rtnl/rtnl-link-dump3.c
@@ -81,7 +81,7 @@ int main(void)
        portid = mnl_socket_get_portid(nl);

        if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
-               perror("mnl_socket_send");
+               perror("mnl_socket_sendto");
                exit(EXIT_FAILURE);
        }

diff --git a/examples/rtnl/rtnl-link-event.c b/examples/rtnl/rtnl-link-event.c
index 90bb8e5..123fb88 100644
--- a/examples/rtnl/rtnl-link-event.c
+++ b/examples/rtnl/rtnl-link-event.c
@@ -26,7 +26,7 @@ static int data_attr_cb(const struct nlattr *attr, void *data)
                break;
        case IFLA_IFNAME:
                if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0) {
-                       perror("mnl_attr_validate2");
+                       perror("mnl_attr_validate");
                        return MNL_CB_ERROR;
                }
                break;
diff --git a/examples/rtnl/rtnl-link-set.c b/examples/rtnl/rtnl-link-set.c
index dad8856..6086c37 100644
--- a/examples/rtnl/rtnl-link-set.c
+++ b/examples/rtnl/rtnl-link-set.c
@@ -62,19 +62,19 @@ int main(int argc, char *argv[])
                          sizeof(struct ifinfomsg));

        if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
-               perror("mnl_socket_send");
+               perror("mnl_socket_sendto");
                exit(EXIT_FAILURE);
        }

        ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
        if (ret == -1) {
-               perror("read");
+               perror("mnl_socket_recvfrom");
                exit(EXIT_FAILURE);
        }

        ret = mnl_cb_run(buf, ret, seq, portid, NULL, NULL);
        if (ret == -1){
-               perror("callback");
+               perror("mnl_cb_run");
                exit(EXIT_FAILURE);
        }

diff --git a/examples/rtnl/rtnl-route-add.c b/examples/rtnl/rtnl-route-add.c
index 6d070b8..97578cd 100644
--- a/examples/rtnl/rtnl-route-add.c
+++ b/examples/rtnl/rtnl-route-add.c
@@ -105,7 +105,7 @@ int main(int argc, char *argv[])
        portid = mnl_socket_get_portid(nl);

        if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
-               perror("mnl_socket_send");
+               perror("mnl_socket_sendto");
                exit(EXIT_FAILURE);
        }

diff --git a/examples/rtnl/rtnl-route-dump.c b/examples/rtnl/rtnl-route-dump.c
index 33cb2df..9829e36 100644
--- a/examples/rtnl/rtnl-route-dump.c
+++ b/examples/rtnl/rtnl-route-dump.c
@@ -182,7 +182,7 @@ static int data_ipv6_attr_cb(const struct nlattr
*attr, void *data)
        case RTA_GATEWAY:
                if (mnl_attr_validate2(attr, MNL_TYPE_BINARY,
                                        sizeof(struct in6_addr)) < 0) {
-                       perror("mnl_attr_validate");
+                       perror("mnl_attr_validate2");
                        return MNL_CB_ERROR;
                }
                break;
@@ -330,7 +330,7 @@ int main(int argc, char *argv[])
        portid = mnl_socket_get_portid(nl);

        if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
-               perror("mnl_socket_send");
+               perror("mnl_socket_sendto");
                exit(EXIT_FAILURE);
        }

diff --git a/examples/rtnl/rtnl-route-event.c b/examples/rtnl/rtnl-route-event.c
index 16d0563..c12b6ae 100644
--- a/examples/rtnl/rtnl-route-event.c
+++ b/examples/rtnl/rtnl-route-event.c
@@ -174,7 +174,7 @@ static int data_ipv6_attr_cb(const struct nlattr
*attr, void *data)
        case RTA_GATEWAY:
                if (mnl_attr_validate2(attr, MNL_TYPE_BINARY,
                                        sizeof(struct in6_addr)) < 0) {
-                       perror("mnl_attr_validate");
+                       perror("mnl_attr_validate2");
                        return MNL_CB_ERROR;
                }
                break;
--
1.7.10.4
