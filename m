From: "Mohammad Mohsenzadeh" <mmohsenz@gmail.com>
Subject: Re: 2.6.20 support for other 'features'
Date: Wed, 11 Apr 2007 13:46:55 -0400
Message-ID: <e6af3bc80704111046k4597b655gbde7f93554d40502@mail.gmail.com>
References: <e6af3bc80704111039x322e55e5qe1ea1568b59214b0@mail.gmail.com>
	<Pine.LNX.4.61.0704111940330.20436@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: "Jan Engelhardt" <jengelh@linux01.gwdg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0704111940330.20436@yvahk01.tjqt.qr>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

> Are not we stateful yet?
> (To answer myself: Technically no, but we are stateful enough
> for most users :-)

That's true, my extension will extend that by looking at the entire
packet payload similar but to layer7 filter and ipp2p projects.

> Four?

The features that can be registered using nf_conntrack_register_cache
is limited to NF_CT_F_NUM which is defined in nf_conntrack.h to 4.

Mohammad
