From: "Martin Koniczek" <martin@koniczek.de>
Subject: Re: pptp-conntrack-nat - problem
Date: Wed, 6 Apr 2005 10:52:39 +0200
Message-ID: <04d701c53a86$012a1150$9c01a8c0@vaion>
References: <1112691812.22295.4.camel@sas> <20050405152410.GA7423@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

>> I try apply pptp-conntrack downloaded directly from SVN
>> and I got error:
>> Kernel:   2.6.11, /home/users/cieciwa/rpm/BUILD/linux-2.6.11.6
> 
> It doesn't work with kernels > 2.6.10 at the moment.

is it much work to make it work with current kernels?
or is there some inofficial "roadmap"/estimates?
or can one outline the steps needed, so i could try my own luck?

i have great interest for this module to work with kernels >2.6.10
(also needing h323-conntrack-nat, connbytes, connrate)
(nice2have owner-socketlookup, owner-supgids, TRACE,
dropped-table, unclean which all seem not to work with 2.6.11.6)
at least, the patches cannot be apllied - perhaps because of changes
which are already in the kernel? mostly ladd troubles...

sincerly,
    martin koniczek
