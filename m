From: Roberto Nibali <ratz@tac.ch>
Subject: Re: [PATCH] multiple devices with ranges match support
Date: Tue, 01 Oct 2002 10:57:48 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3D99638C.204@tac.ch>
References: <638AA0336D7ED411928700D0B7B0D75B03053C9C@aimail.aiinet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Eble, Dan" <DanE@aiinet.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

> Would you ever want to use this on interfaces with secondary addresses, like
> eth0:4?  (Does that even matter?  I'm not too familiar with them; I just
> remember seeing that syntax.)

eth0:4 is _not_ an interface, but a label. The underlying physical interface is 
eth0. Filtering should be per src addr selector and not by names.

Regards,
Roberto Nibali, ratz
-- 
echo '[q]sa[ln0=aln256%Pln256/snlbx]sb3135071790101768542287578439snlbxq' | dc
