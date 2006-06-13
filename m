From: varun <varun@rocsys.com>
Subject: doubt on Redirect
Date: Tue, 13 Jun 2006 16:40:22 +0530
Message-ID: <448E9D1E.9010806@rocsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi all,

              When i use REDIRECT policy will the packet be changed 
before to the redirected port number before giving yo the next module 
registered to the same hook?

               If so why is it that the syn packet from LAN goes through 
but syn-ack from internet is dropped by my fw when used with iptables 
(Only for redirect to squid)?

Varun
