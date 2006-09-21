From: "Mathieu GELI" <mathieu.geli@gmail.com>
Subject: [RFC] SMB extension proposal
Date: Thu, 21 Sep 2006 12:17:23 +0200
Message-ID: <43479bc90609210317q7a3ec3co17b8f8a63ef96df9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi netfilter people,

This mail is a survey to know if people here would find an interest in
having SMB extension to netfilter.

The purpose is doing some SMB grained filtering. What would be the benefit ?
* user filtering/logging
* SMB commands filtering/logging (esp. fs related commands)
* RPC (discussions over named pipes) filtering ability

I'm aware a lot of that could be tweaked on the Windows machine and
that may be the right thing to do . However I'm here in the
perspective of a non trusted environement.
Situations like being able to limit the propagation of a new exploit
using foo windows service from RPC while your machines are still not
patched could be covered.
I think also about logging ability that could help forensic.

Always interested to hear your suggestions,

Cheers

-- 
Mathieu
