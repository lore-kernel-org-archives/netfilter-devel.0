From: Stephen Clark <Stephen.Clark@seclark.us>
Subject: iptables logging
Date: Thu, 15 Nov 2007 15:31:26 -0500
Message-ID: <473CAC9E.6060109@seclark.us>
Reply-To: Stephen.Clark@seclark.us
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpauth12.prod.mesa1.secureserver.net ([64.202.165.35]:52066
	"HELO smtpauth12.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756519AbXKOUiv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2007 15:38:51 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hello,

Is there a way to have iptables LOG using a 
facility other than "kern".
I would like to
segregate out the messages from iptables into a 
file separate from
/var/log/messages.

Any advice would be appreciated.

Steve

-- 

"They that give up essential liberty to obtain 
temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government 
grows, liberty
decreases."  (Thomas Jefferson)




