From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Syncookie firewall
Date: Wed, 5 Jun 2002 21:38:14 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200206052138.14928.hno@marasystems.com>
References: <20020603132204.7934546FF@lists.samba.org> <15614.26348.278645.301276@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: don-nf@isis.cs3-inc.com (Don Cohen),
	netfilter-devel@lists.samba.org
In-Reply-To: <15614.26348.278645.301276@isis.cs3-inc.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Don Cohen wrote:

> There are some tcp options that have to be sent in the syn packet,
> e.g., window scale.  These become unusable if this packet is supplied
> by the firewall, unless the firewall somehow knows how the original
> destination host "would have" answered.  This seems unfortunate, and
> I don't see a good solution.

Not to mention that there is TCP options a firewall cannot know, such as the 
timestamp option.

In my opinion, If you do "syncookie" in a firewall then the TCP should be 
terminated there, with another TCP in to the real server. I.e. a proxy 
solution.

Regards
Henrik Nordström
