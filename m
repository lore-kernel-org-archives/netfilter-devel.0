From: Friedrich Lobenstock <fl@fl.priv.at>
Subject: Re: pom-20040409: patches that break iptables-1.2.9-20040409, kernel
 2.4.25 or pom's runme
Date: Sun, 11 Apr 2004 22:53:33 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4079B04D.2070307@fl.priv.at>
References: <Pine.LNX.4.44.0404112241290.21968-100000@filer.marasystems.com>
Reply-To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.44.0404112241290.21968-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Henrik Nordstrom wrote on 11.04.2004 22:44 MET:
> On Sun, 11 Apr 2004, Friedrich Lobenstock wrote:
> 
> 
>>   1) base/set
>>        a "make" of iptables does not even succeed to
>>        create the dependencies, message
>>          "Something wrong... deleting dependencies."
> 
> 
> This is because the set extension depends on libipset which is no longer
> in the iptables source tree..

In that case please remove base/set from pom!

-- 
MfG / Regards
Friedrich Lobenstock
