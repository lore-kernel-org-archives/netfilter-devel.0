From: Dinil Divakaran <dinil@lantana.tenet.res.in>
Subject: Re: stability of IMQ?
Date: Thu, 2 Sep 2004 09:28:05 +0530 (IST)
Sender: netfilter-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.60.0409020925530.3129@dahlia.cs.iitm.ernet.in>
References: <876ef97a040901130117c0e91a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: linux-net <linux-net@vger.kernel.org>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>,
	netfilter <netfilter@lists.netfilter.org>
Return-path: <netfilter-bounces@lists.netfilter.org>
To: Tobias DiPasquale <codeslinger@gmail.com>
In-Reply-To: <876ef97a040901130117c0e91a@mail.gmail.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

>
> I am considering using IMQ for some ingress shaping action and I was
> wondering if anyone else was using it and how stable it is. Have their
> been an persistent Oops problems? Any other serious issues? The site
> seems to indicate some problems in certain situations, so I was
> wondering about this before I got into it too heavily. Thanks for all
> the help in advance!

I 've used IMQ on kernel 2.4.21 and it doesn't seem to have
any kind of problem.

I couldn't get it working for 2.6.7 kernel. There was some problem
patching iptabels !

Cheers,
Dinil
