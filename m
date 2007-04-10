From: "Si Tiange" <mailinglist.si@gmail.com>
Subject: Help about writing netfilter extensions
Date: Tue, 10 Apr 2007 15:42:45 +0800
Message-ID: <bc0920ac0704100042i62b03853ib4391b93a0b9f126@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
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

hi,

I'm trying to setup my linux box as a network bridge. The network
bridge will search all the packets through it for the ones of some
specific protocol, such as RTP, to modify their contents. The
modification is adding a checksum into one RTP packet's body.

I've read Linux netfilter Hacking HOWTO and source code of ipt_TOS.
And I guess I should write a new match module and a new target module.
The matcher locates the packets according the user assigned protocol,
the new target module will modify the body of such packets. I am
newbie to netfilter and have no idea if it works, so I need some
advice and the detailed information about the idea.

Thank you.
