From: "Stephan Jager" <netfilter@medz.org>
Subject: H.323 conntrack patch
Date: Mon, 14 Jul 2003 17:39:24 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200307141539.h6EFdOwT002543@alpha.medz.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
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

(I'm new here, so if I	post too much/too little information, please tell 
me so)

I'm trying to use the H.323 conntrack module for my AddPac Voicefinder 
device. It seems that it works only "half" in my situation.
I've turned on debugging for the h323 modules, but I could not see 
anything suspicous in the first place.

The function: "static int h225_help" contains a 
ip_conntrack_expect_related call, which seems to work. (it registers a 
incoming call derived from the h.225 package). This one is called first in 
sequence. Those packages are going to my Voicefinder device 
(private network)without problems.

Furthermore, in the "static int h245_help" function, there is also a 
ip_conntrack_expect_related call. This one is also registered (twice), but 
connections for this conntrack are not going to my private network. (this 
is registered 2nd and 3th) It seems that netfilter does not match those 
packages, altough the logging says so.

Perhaps anybody can see at the code if there's anything obvious wrong? I 
can give you a full package-state + debug logging, but I guess thats too 
much for now.

Is there a good way to see the way a package flows? I've trying to turn on 
logging in the ip_conntrack_core, but thats way too much :)

If I've got this running, I'm going to write a H.245 RAS (gatekeeper) 
module, but I need to get this protocol running first fine.

With regards,

Stephan

------ End of forwarded message -------
