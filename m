From: John Williams Floroiu <floroiu@fokus.fraunhofer.de>
Subject: initialization of program_version --- was: Re: segfault when linking
 with libiptables
Date: Fri, 05 Mar 2004 12:25:39 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <404863B3.5060709@fokus.fraunhofer.de>
References: <40470052.8050004@fokus.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
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


hi,

this is because of the "program_version", which is referenced in "register_match" and needs 
therefore to be initialized before calling "find_match".

wouldn't be it better to have it set by libiptables itself, rather that in iptables_standalone.c?

cheers,
John.
