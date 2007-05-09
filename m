From: "Michael Ransburg" <michael.ransburg@gmail.com>
Subject: Re: Userspace packet queuing with libipq: ip_conntrack does not
	defragment?
Date: Wed, 9 May 2007 17:52:25 +0200
Message-ID: <22b256140705090852p5a9c512ck67993032641c8589@mail.gmail.com>
References: <22b256140705090832v556bee45ne5119d529a7e310e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <22b256140705090832v556bee45ne5119d529a7e310e@mail.gmail.com>
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

> Any suggestions what I'm doing wrong?

A small update: I found out (through this presentation:
http://ants.iis.sinica.edu.tw/linux_summer_school/Connection%20Tracking.ppt#262,5,Slide
5) that defragmentation is only available in the prerouting and output
chains. I therefore changed my iptables rule to OUTPUT, but I'm
getting the same result, i.e., maximum packet sizes of 1500.

Any hints are appreciated.

Thanks,
Michael

-- 
icq: 71772353 | skype: daneel1409 | msn: mike@unfolded.com
