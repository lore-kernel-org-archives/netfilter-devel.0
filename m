From: "miguel Angel Vazquez" <mikinho21@gmail.com>
Subject: Libipq problem
Date: Thu, 19 Apr 2007 11:21:59 +0200
Message-ID: <f015bcab0704190221u70fe1d9by1808eac18f53e669@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
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

Hi all!
First of all I want to apologize for my English.

I know libipq has been changed but I'm working with a embedded Linux
2.4.xx kernel in a Linksys Router (using OpenWRT), and I can't change
to the newest version. The fact is I have developed an application
which read the HTTP payload and erase the HTTP-headers (in HTTP/1.1
only host header has to be sent).

(TCP spoofing in order to simulate a TCP split PEP-proxy)

It works, correcting the checksums, the total lenght of the
packet...but when it reinjects and send the package it produces some
incompleted copies of the sent package in the queue. My receiver is
reciving 2 "bad-repeated" packages (3 packages at all).

I've read this behaviour appears when the packet changes its size
(other developers' experience and posts), but I don't have find any
answer.

Is this behaviour normal??any idea?
