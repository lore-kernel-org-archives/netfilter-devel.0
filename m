From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/2] GTP tunneling fixes for net
Date: Thu, 15 Dec 2016 22:35:51 +0100
Message-ID: <1481837753-10317-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, laforge@gnumonks.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi David,

The following patchset contains two GTP tunneling fixes for your net
tree, they are:

1) Offset to IPv4 header in gtp_check_src_ms_ipv4() is incorrect, thus
   this function always succeeds and therefore this defeats this sanity
   check. This allows packets that have no PDP to go though, patch from
   Lionel Gauthier.

2) According to Note 0 of Figure 2 in Section 6 of 3GPP TS 29.060 v13.5.0
   Release 13, always set GTPv1 reserved bit to zero. This may cause
   interoperability problems, patch from Harald Welte.

Please, apply, thanks a lot!

Harald Welte (1):
  gtp: Fix initialization of Flags octet in GTPv1 header

Lionel Gauthier (1):
  gtp: gtp_check_src_ms_ipv4() always return success

 drivers/net/gtp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

-- 
2.1.4
