From: "Xiaonan Lu" <zplxn@mail.com>
Subject: Questions
Date: Wed, 12 Nov 2003 14:26:18 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031112192618.16434.qmail@mail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
Content-Disposition: inline
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

Hi, 
I am a new guy to linux and netfilter/proc. 
I am working on a program right now, its main purpose is develope a module to peek every outgoing packet to log the timestamp information. I hook this module at the netfilter's POST_ROUTING hook. 
Questions: 
When my module is hooked and begin to run, I can not use netscape, ssh, .etc anymore. The typical result is: I type: ssh <hostname> -l username, the machine seems to stop, no any response except I stop my module. It seems every IP packet were stop by somebody. In my module, I don't drop any packet, for every packet I get, I just record the timestamp and return NF_ACCEPT. 
Thanks
ping

-- 
__________________________________________________________
Sign-up for your own personalized E-mail at Mail.com
http://www.mail.com/?sr=signup

Search Smarter - get the new eXact Search Bar for free!
http://www.exactsearchbar.com/
