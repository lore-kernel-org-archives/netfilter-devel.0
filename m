From: varun <varun@rocsys.com>
Subject: patch for rule insert
Date: Tue, 04 Jul 2006 09:06:25 +0530
Message-ID: <44A9E239.8080403@rocsys.com>
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

                I would loke to know if any of you have  a patch for 
inserting rule anywhere in the middle of the chain.
                That is with -A we append the new rule and -I we add the 
new rule to the top of the chain. So i wold like to insert it in middle 
of the chain. Is it possible? Does anyone have a patch for the same?

Varun
