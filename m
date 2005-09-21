From: JC <bikkit@gmail.com>
Subject: Re: netfilter hook function error...
Date: Wed, 21 Sep 2005 02:14:03 +0100
Message-ID: <a60102c3050920181433a26168@mail.gmail.com>
References: <a60102c3050920171352ae872c@mail.gmail.com>
Reply-To: JC <bikkit@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
In-Reply-To: <a60102c3050920171352ae872c@mail.gmail.com>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

correct my_ipheader =3D skb->nh->iph;

with my_ipheader =3D skb->nh.iph;

and it does NOT work.


includes:
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/init.h>
#include <linux/sched.h>
#include <linux/tty.h>
#include <linux/version.h>

#include <linux/netdevice.h>
#include <linux/netfilter.h>
#include <linux/netfilter_ipv4.h>

#include <linux/skbuff.h>

#include <linux/ip.h>
#include <linux/udp.h>
#include <linux/tcp.h>

J
