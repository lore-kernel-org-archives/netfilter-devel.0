From: "Eble, Dan" <DanE@aiinet.com>
Subject: RE: [PATCH] multiple devices with ranges match support
Date: Wed, 18 Sep 2002 14:52:31 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <638AA0336D7ED411928700D0B7B0D75B03053C9C@aimail.aiinet.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> -----Original Message-----
> From: Jay Schulist [mailto:jschlst@linux-sna.org] 
> mdev v1.2.7a options:
...
>  --i dev[,dev:dev,dev...]       match inbound device(s)
>  --o dev[,dev:dev,dev...]       match outbound device(s)

Would you ever want to use this on interfaces with secondary addresses, like
eth0:4?  (Does that even matter?  I'm not too familiar with them; I just
remember seeing that syntax.)
