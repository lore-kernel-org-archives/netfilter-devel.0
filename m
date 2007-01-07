From: Alexander Sirotkin <demiurg@metalinkBB.com>
Subject: netfilter performance on low-end embedded systems
Date: Sun, 07 Jan 2007 15:24:54 +0200
Message-ID: <45A0F4A6.8060000@metalinkbb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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


Hello.

I'm trying to evaluate the feasibility of using netfilter on low-end 
embedded processors, such as MIPS 4K or 24K. Basicly what I'm trying to 
understand is whether we can do 100Bps with netfilter enabled (firewall 
and NAT) on such a CPU or should we check hardware acceleration solution.

If anybody did any similar benchmarks and can share results (does not 
have to be on MIPS) or just has any opinion on the subject - I'd be very 
grateful.

Thanks a lot.

-- 
Alexander Sirotkin

System Engineer
System Architecture Group

Metalink Broadband Ltd.

Phone:   +972-9-9605360
Fax:     +972-9-9605344
Mobile: +972-54-4959034


-- Disclaimer: --
This e-mail is intended solely for the person to whom it is addressed and may contain confidential or legally privileged information. Access to this e-mail by anyone else is unauthorized. If an addressing or transmission error has misdirected this e-mail, please notify the author by replying to this e-mail and destroy this e-mail and any attachments.
E-mail may be susceptible to data corruption, interception, unauthorized amendment, viruses and delays or the consequences thereof. If you are not the intended recipient, be advised that you have received this email in error and that any use, dissemination, forwarding, printing or copying of this email is strictly prohibited.
