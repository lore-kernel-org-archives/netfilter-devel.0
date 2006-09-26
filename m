From: "miguel Angel Vazquez" <mikinho21@gmail.com>
Subject: libipq??
Date: Tue, 26 Sep 2006 12:43:10 +0200
Message-ID: <f015bcab0609260343m792e9c5co40a522a0384a0fe6@mail.gmail.com>
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

Hi mates!
I'm involved in a embedded Linux project. We are using a busybox with
a 2.4.xx kernel. I have to use Iptables in order to queue the TCP
packets and afterwards I have to mangle them in order to reduce
non-usefull information on the payload.

I've read about using ip_queue /libipq, however netfilter has changed
it (with the 2.6 kernels...I agree with the this change). I've used
the SVN repository in order to get a iptables version which has
libipq. Have I to download ip_queue or it is allready included in the
SVN?

any advise??

Thanks!
Miguel
