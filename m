From: "Kevin P. Fleming" <kpfleming@starnetworks.us>
Subject: Active SIP conntrack/NAT development?
Date: Wed, 25 Aug 2004 08:01:38 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <412CA9D2.4030506@starnetworks.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
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
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

After perusing the list archives, I see that two or three people in the 
past year or so have started working on SIP/SDP/RTP conntrack/NAT 
helpers, but none of them have apparently gotten to a usable state.

I want to get this done, I need to be able to use it soon :-) I am 
willing to put the time in to make this work, and I believe I have 
enough skills to get it done.

If there are any starting points out there (other than the code that 
Dominik posted a year ago) I'd appreciate pointers to them, otherwise 
I'll just take the existing FTP/H.323 examples and go from there. Also, 
if there are any available docs on making helpers that will work with 
both 2.4 and 2.6 kernels that would be appreciated as well.
