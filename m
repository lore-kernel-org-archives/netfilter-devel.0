From: shobhan <shobhankumar-rc@naturesoft.net>
Subject: Re: About the iptc library
Date: Mon, 17 Mar 2003 18:12:24 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E75C2B0.4050605@naturesoft.net>
References: <001f01c2e943$57b36350$4f241cac@nechk.nec.com.hk>
Mime-Version: 1.0
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Louis Lau <louis_lau@nechk.nec.com.hk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Seems you are not giving -rdynamic flag in gcc.

try with giving "-rdynamic" with gcc.

Cheers
Shobhan

Louis Lau wrote:

>Dear all developers,
>
>Hi there, I have been using iptables for sometime and since there are so
>many parameters i need to set, i have made a GUI interface to handle my
>configuration. In my GUI, i use ORBit CORBA so that my server (written in C)
>can talk to my Java applet. Then i can control the firewall through the java
>interface remotely. However, the method i use in my server to get the
>iptable is very simple.. i use popen to call iptables and then transfer the
>result, pack it into some data structure and then send back to the java
>client. This has a flaw as i think most of u will know as anyoner can type
>in any command in my field and hack to my computer.. (like in the field for
>remarks, the user may type "& reboot" then my computer will reboot. I have
>done something to filter out any 'troblesome' characters but i think this
>doesn't make the GUI more secure... especially if i want to put this in a
>sourceforge project and ppl can easily write another client program to
>interact with the server program. So i have started to look at the source
>code of iptables and see if i can integrate the source code in my server
>program. (ie. change my server program to a client of the kernel netfilter
>functions) But i have some problems in doing this as i haven't program much
>in Linux before indeed, so i hope in this list, someone can give me hints on
>how to do about this.... =)
>
>in the iptables source code, i found that iptables.c has all the functions
>to control the netfilter, so i just want to be able to use the do_command()
>function in my server program and that will do my job. i put the iptables.c
>and the include directory in my testing directory,
>and then i write a short main program to parse the user input to the
>do_command function. (just like the iptables-standalone.c do) I initially
>recieve some error as it can not load the share library libiptc*. I find
>that there are some share object in /usr/include/lib/iptables, so i do
>ldconfig -v -n /usr/include/lib/iptables
>ln -sf libipt_standard.so libipt_standard.so.1
>export LD_LIBRARY_PATH=/usr/include/lib/iptables
>After that i can compile the program by adding -lipt_standard in the compile
>line.... the program compile but when i call my program, it recieve
>segmentation fault. If i don't add the dynamic link of libipt_standard.so
>and i don't compile with this library, the function won't have segmentation
>fault but it yeilds:
>couldn't load target 'standard':/usr/local/lib/iptables/libipt_standard.so:
>undefined symbol: register_target
>
>So can you give me some hints why this happens? or do i need to recompile
>the kernel in order to do this? (I suspect not as i can compile the iptables
>source code and work with my current kernel....)
>
>Thanks in advance.
>
>cheers
>
>Louis
>
>
>
>
