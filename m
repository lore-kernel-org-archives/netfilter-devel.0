From: "Julien DHERSIN" <dhersin@gmail.com>
Subject: Re: libnetfilter_queue man page
Date: Tue, 27 Feb 2007 09:05:10 +0100
Message-ID: <2e25cc380702270005sfdf44a3q50305cdfa65b4732@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: "Netfilter Development" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hi,

First, thanks for the documentation. It was helpful for me to understand the
code.

But, I still have a question : I would like to add an extension in filtered IPv6
multicast packets headers. Do you think, I can do this in the userspace
using libnetfilter queue ? And, how precisely does it work ? Is it something
like this :

1. Activate the hook NF_IP6_LOCAL_OUT with an iptables rule
2. Launch my software with libnetfilter_queue
3. Modify the header
4. Return the whole packet to netfilter

Do I have tocreate a specific kernel module ?

Thanks for your responses.

Regards,
Julien
