From: Gervasio Bernal <gervasiobernal@speedy.com.ar>
Subject: Re: New extension: CRYPT target
Date: Tue, 23 May 2006 20:13:14 -0300
Message-ID: <4473970A.9050008@speedy.com.ar>
References: <44708E68.9080508@speedy.com.ar> <44709CFC.7050007@gmx.net>
	<"447 0D859.7000706"@speedy.com.ar> <4470E716.1090001@gmx.net>
	<4473380F.5050102@speedy.com.ar> <44733C72.1020008@gmx.net>
	<44734149.2040900@trash.net> <447342F4.2010405@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7BIT
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-reply-to: <447342F4.2010405@gmx.net>
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

Carl-Daniel Hailfinger wrote:
> Patrick McHardy wrote:
> 
>>Carl-Daniel Hailfinger wrote:
>>
>>>Gervasio Bernal wrote:
>>>
>>>
>>>>One possible solution would be to use a file to store the key, and chmod
>>>>that file.That would be correct?
>>>
>>>No. Still leaves a race. You have to chmod the file before you store the
>>>key in it. Then it would be ok.
>>
>>You are both very wrong :) What prevents someone from opening it
>>before the chmod, and read it afterwards? This is what umask is
>>for ..
> 
> 
> umask alone won't help. If an attacker creates a file with the same
> name in the same place before you open it and has that file open
> before you write to it, he will still win. Correct umask and
> opening it with O_CREAT|O_EXCL should mostly be safe, though.
> I assume you want to do all this stuff as root. If /root is
> only readable by root, create the file there and you should be
> safe.
> 

The idea of using a file is like this:
1- Being root, create a file called /root/file1.key
#touch /root/file1.key
#ls -al /root/file1.key
-rw-r--r--  1 root root 0 May 23 20:05 file1.key

2- Change permissions
#chmod 600 /root/file1.key
#ls -al /root/file1.key
-rw-------  1 root root 0 May 23 20:05 file1.key

3- Open /root/file1.key and add a key

4- Use file1.key in CRYPT extension
#iptables -t mangle -A PREROUTING -p 206 -j CRYPT --cipher aes --mode
cbc --fkey /root/file1.key --direction decrypt
Where fkey is an argument that receives the key file to use.

> Regards,
> Carl-Daniel
