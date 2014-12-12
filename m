From: leroy christophe <christophe.leroy@c-s.fr>
Subject: bug : nft_redirect port byteorder issue
Date: Fri, 12 Dec 2014 11:16:29 +0100
Message-ID: <548AC07D.6080703@c-s.fr>
References: <54885B08.1010700@c-s.fr> <20141210182244.GA5622@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org, GUITTON Alex <alex.guitton@c-s.fr>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	arturo.borrero.glez@gmail.com
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <20141210182244.GA5622@salvia>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

table ip nat {
         chain prerouting {
                  type nat hook prerouting priority 0;
                  tcp dport 222 redirect :22
         }
         chain postrouting {
                  type nat hook postrouting priority 0;
         }
}

With the above rules, data[priv->sreg_proto_min].data[0] has value 
0x160000 instead of 0x16 on powerpc (Big Endian byte order)

Due to this, mr.range[0].min.all gets assigned value 0 instead of 22.

Below patch fixes it, but it is maybe not the proper way to fix it, so I 
let it up to you.

Christophe

diff --git a/net/ipv4/netfilter/nft_redir_ipv4.c 
b/net/ipv4/netfilter/nft_redir_ipv4.c
index 643c596..554bb32 100644
--- a/net/ipv4/netfilter/nft_redir_ipv4.c
+++ b/net/ipv4/netfilter/nft_redir_ipv4.c
@@ -28,9 +28,9 @@ static void nft_redir_ipv4_eval(const struct nft_expr 
*expr,
  	memset(&mr, 0, sizeof(mr));
  	if (priv->sreg_proto_min) {
  		mr.range[0].min.all = (__force __be16)
-					data[priv->sreg_proto_min].data[0];
+					*(__be16*)&data[priv->sreg_proto_min].data[0];
  		mr.range[0].max.all = (__force __be16)
-					data[priv->sreg_proto_max].data[0];
+					*(__be16*)&data[priv->sreg_proto_max].data[0];
  		mr.range[0].flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
  	}

