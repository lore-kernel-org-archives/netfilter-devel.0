From: Patrick McHardy <kaber@trash.net>
Subject: Question: Variable sized matchinfo
Date: Mon, 20 Jan 2003 13:14:30 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E2BE826.7020502@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi.

I want to write a match where it would be nice to pass a variable sized 
matchinfo to kernelspace.
Is this possible ? I want to avoid always using the largest possible 
values (2^16 + a few bytes).
The data in question is a bpf program compiled with pcap_compile ..
This is probably not the most useful match but i think it beats u32 
because bpf syntax is already well-known
and very pleasant to use.

Regards,
Patrick
